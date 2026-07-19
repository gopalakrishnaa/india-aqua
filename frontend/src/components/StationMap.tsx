"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { createPortal } from "react-dom";
import Map, {
  Layer,
  Marker,
  NavigationControl,
  Popup,
  Source,
  type MapRef,
} from "react-map-gl/maplibre";
import Link from "next/link";
import "maplibre-gl/dist/maplibre-gl.css";
import { SEVERITY_META, severityOf } from "@/lib/status";
import type { Reading, Station } from "@/lib/types";

// Free, keyless vector basemap. CARTO's CDN-backed style, built for
// unlimited public use (unlike raw OSM tiles, which rate-limit automated
// traffic per their usage policy).
const BASEMAP_STYLE = "https://basemaps.cartocdn.com/gl/positron-gl-style/style.json";

// India's boundary per the Survey of India (includes Jammu & Kashmir,
// Ladakh, Aksai Chin, and Pakistan-occupied Kashmir), overlaid because the
// base map's own borders follow the internationally-neutral treatment most
// global providers use for this disputed region.
// Source: DataMeet (github.com/datameet/maps), simplified for web display.
const INDIA_BOUNDARY_URL = "/geo/india-boundary.geojson";

// Shown only until the first fitBounds() resolves once station coordinates
// are known. An approximate India-wide framing, not a fixed default.
const FALLBACK_VIEW = { longitude: 82.5, latitude: 26, zoom: 4 };

const FIT_BOUNDS_PADDING = { top: 100, bottom: 40, left: 40, right: 40 };
const FIT_BOUNDS_MAX_ZOOM = 8;

type StationWithIssues = Station & { issueCount: number; latest: Reading | null };
type LngLatBounds = [[number, number], [number, number]];

function boundsOf(stations: Station[]): LngLatBounds | null {
  const coords = stations
    .filter((s): s is Station & { latitude: number; longitude: number } =>
      s.latitude !== null && s.longitude !== null,
    )
    .map((s) => [s.longitude, s.latitude] as [number, number]);
  if (coords.length === 0) return null;

  let [minLng, minLat] = coords[0];
  let [maxLng, maxLat] = coords[0];
  for (const [lng, lat] of coords) {
    if (lng < minLng) minLng = lng;
    if (lng > maxLng) maxLng = lng;
    if (lat < minLat) minLat = lat;
    if (lat > maxLat) maxLat = lat;
  }
  return [
    [minLng, minLat],
    [maxLng, maxLat],
  ];
}

export function StationMap({
  stations,
  readingsByStation,
}: {
  stations: Station[];
  readingsByStation: Map<number, { reading: Reading; issueCount: number }>;
}) {
  const [selected, setSelected] = useState<StationWithIssues | null>(null);
  const mapRef = useRef<MapRef>(null);
  const hasFitOnce = useRef(false);

  const points = useMemo<StationWithIssues[]>(
    () =>
      stations
        .filter((s) => s.latitude !== null && s.longitude !== null)
        .map((s) => {
          const entry = readingsByStation.get(s.id);
          return { ...s, issueCount: entry?.issueCount ?? 0, latest: entry?.reading ?? null };
        }),
    [stations, readingsByStation],
  );

  // Frame every known station on load, and re-frame when the station set
  // itself changes (e.g. river filter), but not on every readings poll.
  const bounds = useMemo(() => boundsOf(stations), [stations]);

  useEffect(() => {
    if (!bounds || !hasFitOnce.current || !mapRef.current) return;
    mapRef.current.fitBounds(bounds, {
      padding: FIT_BOUNDS_PADDING,
      maxZoom: FIT_BOUNDS_MAX_ZOOM,
      duration: 800,
    });
  }, [bounds]);

  return (
    <Map
      ref={mapRef}
      initialViewState={FALLBACK_VIEW}
      style={{ flex: 1 }}
      mapStyle={BASEMAP_STYLE}
      onLoad={() => {
        if (bounds) {
          mapRef.current?.fitBounds(bounds, {
            padding: FIT_BOUNDS_PADDING,
            maxZoom: FIT_BOUNDS_MAX_ZOOM,
            duration: 0,
          });
        }
        hasFitOnce.current = true;
      }}
    >
      <NavigationControl position="bottom-right" />

      <Source id="india-boundary" type="geojson" data={INDIA_BOUNDARY_URL}>
        <Layer
          id="india-boundary-fill"
          type="fill"
          paint={{ "fill-color": "#0ea5e9", "fill-opacity": 0.04 }}
        />
        <Layer
          id="india-boundary-line"
          type="line"
          paint={{ "line-color": "#0e7490", "line-width": 2 }}
        />
      </Source>

      {points.map((s) => {
        const sev = severityOf(s.issueCount);
        const meta = SEVERITY_META[sev];
        return (
          <Marker
            key={s.id}
            longitude={s.longitude!}
            latitude={s.latitude!}
            onClick={(e) => {
              e.originalEvent.stopPropagation();
              setSelected(s);
            }}
          >
            <button
              aria-label={`${s.name}, ${meta.label}`}
              className="grid h-10 w-10 place-items-center cursor-pointer"
            >
              <span
                className={`relative block h-4 w-4 rounded-full border-2 border-white aqua-marker ${
                  sev === "critical" ? "aqua-pulse" : ""
                }`}
                style={{ backgroundColor: meta.hex, color: meta.hex }}
              />
            </button>
          </Marker>
        );
      })}

      {selected && selected.latitude !== null && selected.longitude !== null && (
        <Popup
          longitude={selected.longitude}
          latitude={selected.latitude}
          onClose={() => setSelected(null)}
          closeButton={false}
          closeOnClick={false}
          offset={14}
          maxWidth="260px"
        >
          <StationPopup station={selected} onClose={() => setSelected(null)} />
        </Popup>
      )}
    </Map>
  );
}

function formatRelativeTime(iso: string): string {
  const diffMs = Date.now() - new Date(iso).getTime();
  const minutes = Math.round(diffMs / 60_000);
  if (minutes < 1) return "just now";
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.round(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.round(hours / 24);
  return `${days}d ago`;
}

const PARAM_INFO: { label: string; why: string }[] = [
  {
    label: "WQI (Water Quality Index)",
    why: "A single 0-100 score combining pH, DO, BOD, COD, and turbidity into one number, so water quality can be compared across stations at a glance.",
  },
  {
    label: "pH",
    why: "How acidic or alkaline the water is. Safe range is roughly 6.5-8.5. Outside it, aquatic life is harmed and it often signals industrial or sewage discharge.",
  },
  {
    label: "Dissolved Oxygen (DO)",
    why: "Oxygen dissolved in the water that fish and other aquatic life need to survive. Low DO usually means heavy organic pollution is consuming the oxygen.",
  },
  {
    label: "BOD (Biochemical Oxygen Demand)",
    why: "How much oxygen microbes use while breaking down organic waste in the water. High BOD points to sewage or organic effluent pollution.",
  },
  {
    label: "COD (Chemical Oxygen Demand)",
    why: "Total oxygen needed to break down both organic and chemical pollutants, including ones microbes can't digest. Flags industrial/chemical contamination that BOD alone misses.",
  },
  {
    label: "Turbidity",
    why: "Cloudiness caused by suspended particles. High turbidity blocks sunlight for aquatic plants and can carry pathogens attached to those particles.",
  },
];

type Usability = { label: string; tone: string };

// CPCB's "Primary Water Quality Criteria" for designated best-use classes A
// (drinking, after disinfection only) and B (outdoor bathing) also require
// total coliform, which isn't in this dataset, so this is an approximation
// from pH/DO/BOD alone, not an official CPCB classification.
function usabilityOf(latest: Reading | null): Usability | null {
  if (!latest) return null;
  const { ph, dissolved_oxygen_mg_l: doVal, bod_mg_l: bod } = latest;
  if (ph == null || doVal == null || bod == null) return null;

  const phOk = ph >= 6.5 && ph <= 8.5;
  if (phOk && doVal >= 6 && bod <= 2) {
    return { label: "Drinkable", tone: "bg-emerald-50 text-emerald-700" };
  }
  if (phOk && doVal >= 5 && bod <= 3) {
    return { label: "Bathable", tone: "bg-sky-50 text-sky-700" };
  }
  return { label: "Not bathable or drinkable", tone: "bg-rose-50 text-rose-700" };
}

function ParamInfoModal({ onClose }: { onClose: () => void }) {
  return createPortal(
    <div
      className="fixed inset-0 z-[1000] flex items-center justify-center bg-slate-900/40 p-4"
      onClick={onClose}
    >
      <div
        className="max-h-[80vh] w-full max-w-sm overflow-y-auto rounded-xl bg-white p-4 shadow-xl"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between">
          <h3 className="text-sm font-semibold text-slate-900">Why these parameters matter</h3>
          <button
            type="button"
            aria-label="Close"
            onClick={onClose}
            className="grid h-7 w-7 place-items-center rounded-md text-slate-400 hover:bg-slate-100 hover:text-slate-700"
          >
            ✕
          </button>
        </div>
        <dl className="mt-3 space-y-3">
          {PARAM_INFO.map((p) => (
            <div key={p.label}>
              <dt className="text-xs font-semibold text-slate-800">{p.label}</dt>
              <dd className="mt-0.5 text-xs leading-relaxed text-slate-600">{p.why}</dd>
            </div>
          ))}
        </dl>
      </div>
    </div>,
    document.body,
  );
}

function StationPopup({
  station,
  onClose,
}: {
  station: StationWithIssues;
  onClose: () => void;
}) {
  const meta = SEVERITY_META[severityOf(station.issueCount)];
  const latest = station.latest;
  const usability = usabilityOf(latest);
  const [showInfo, setShowInfo] = useState(false);

  return (
    <div className="w-56">
      <div className="flex items-start justify-between gap-2">
        <div className="min-w-0">
          <p className="font-semibold text-slate-900 leading-tight truncate">{station.name}</p>
          <p className="text-xs text-slate-500 mt-0.5 truncate">
            {station.river} · {station.location}
          </p>
        </div>
        <button
          type="button"
          aria-label="Close"
          onClick={onClose}
          className="shrink-0 grid h-8 w-8 place-items-center rounded-md text-slate-400 hover:bg-slate-100 hover:text-slate-700"
        >
          ✕
        </button>
      </div>

      <div className="mt-2 flex items-center gap-2">
        <span
          className={`inline-flex items-center gap-1.5 rounded-full px-2 py-0.5 text-xs font-medium ${meta.pill}`}
        >
          <span className={`h-1.5 w-1.5 rounded-full ${meta.dot}`} />
          {meta.label}
          {station.issueCount > 0 && ` · ${station.issueCount} issue${station.issueCount > 1 ? "s" : ""}`}
        </span>
        {latest?.recorded_at && (
          <span className="text-xs text-slate-400" title={new Date(latest.recorded_at).toLocaleString()}>
            {formatRelativeTime(latest.recorded_at)}
          </span>
        )}
      </div>

      {latest?.wqi != null && (
        <div className="mt-2.5 flex items-baseline gap-2 rounded-lg bg-cyan-50 px-2.5 py-1.5">
          <span className="text-xs text-slate-500">WQI</span>
          <span className="text-base font-semibold text-slate-900 tabular-nums">{latest.wqi}</span>
          {latest.quality_class && (
            <span className="ml-auto text-xs font-medium text-cyan-700">{latest.quality_class}</span>
          )}
        </div>
      )}

      {latest ? (
        <dl className="mt-2.5 grid grid-cols-2 gap-x-3 gap-y-1.5 text-xs">
          <div>
            <dt className="text-slate-400">pH</dt>
            <dd className="font-medium text-slate-800">{latest.ph ?? "N/A"}</dd>
          </div>
          <div>
            <dt className="text-slate-400">DO (mg/L)</dt>
            <dd className="font-medium text-slate-800">{latest.dissolved_oxygen_mg_l ?? "N/A"}</dd>
          </div>
          <div>
            <dt className="text-slate-400">BOD (mg/L)</dt>
            <dd className="font-medium text-slate-800">{latest.bod_mg_l ?? "N/A"}</dd>
          </div>
          <div>
            <dt className="text-slate-400">Turbidity</dt>
            <dd className="font-medium text-slate-800">{latest.turbidity_ntu ?? "N/A"}</dd>
          </div>
        </dl>
      ) : (
        <p className="mt-2.5 text-xs text-slate-500">No recent readings</p>
      )}

      <button
        type="button"
        onClick={() => setShowInfo(true)}
        className="mt-2 flex items-center gap-1 text-xs text-slate-500 hover:text-cyan-700"
      >
        <span className="grid h-4 w-4 place-items-center rounded-full border border-slate-300 text-[10px] font-semibold">
          i
        </span>
        What do these mean?
      </button>

      {usability && (
        <div className={`mt-2.5 rounded-lg px-2.5 py-1.5 text-center text-xs font-medium ${usability.tone}`}>
          {usability.label}
        </div>
      )}

      <Link
        href={`/stations/${station.id}`}
        className="mt-3 flex items-center justify-center gap-1 rounded-lg bg-cyan-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-cyan-700"
      >
        View history →
      </Link>

      {showInfo && <ParamInfoModal onClose={() => setShowInfo(false)} />}
    </div>
  );
}
