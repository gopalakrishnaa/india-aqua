"use client";

import { useMemo, useState } from "react";
import Map, { Layer, Marker, Popup, Source } from "react-map-gl/maplibre";
import Link from "next/link";
import "maplibre-gl/dist/maplibre-gl.css";
import { SEVERITY_META, severityOf } from "@/lib/status";
import type { Reading, Station } from "@/lib/types";

// Free, keyless vector basemap — CARTO's CDN-backed style, built for
// unlimited public use (unlike raw OSM tiles, which rate-limit automated
// traffic per their usage policy).
const BASEMAP_STYLE = "https://basemaps.cartocdn.com/gl/positron-gl-style/style.json";

// India's boundary per the Survey of India (includes Jammu & Kashmir,
// Ladakh, Aksai Chin, and Pakistan-occupied Kashmir), overlaid because the
// base map's own borders follow the internationally-neutral treatment most
// global providers use for this disputed region.
// Source: DataMeet (github.com/datameet/maps), simplified for web display.
const INDIA_BOUNDARY_URL = "/geo/india-boundary.geojson";

type StationWithIssues = Station & { issueCount: number; latest: Reading | null };

export function StationMap({
  stations,
  readingsByStation,
}: {
  stations: Station[];
  readingsByStation: Map<number, { reading: Reading; issueCount: number }>;
}) {
  const [selected, setSelected] = useState<StationWithIssues | null>(null);

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

  return (
    <Map
      initialViewState={{ longitude: 82.5, latitude: 26, zoom: 5 }}
      style={{ flex: 1 }}
      mapStyle={BASEMAP_STYLE}
    >
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
              aria-label={`${s.name} — ${meta.label}`}
              className={`relative block h-4 w-4 rounded-full border-2 border-white cursor-pointer aqua-marker ${
                sev === "critical" ? "aqua-pulse" : ""
              }`}
              style={{ backgroundColor: meta.hex, color: meta.hex }}
            />
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
          anchor="bottom"
          offset={14}
          maxWidth="260px"
        >
          <StationPopup station={selected} onClose={() => setSelected(null)} />
        </Popup>
      )}
    </Map>
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
          className="shrink-0 grid h-5 w-5 place-items-center rounded-md text-slate-400 hover:bg-slate-100 hover:text-slate-700"
        >
          ✕
        </button>
      </div>

      <span
        className={`mt-2 inline-flex items-center gap-1.5 rounded-full px-2 py-0.5 text-xs font-medium ${meta.pill}`}
      >
        <span className={`h-1.5 w-1.5 rounded-full ${meta.dot}`} />
        {meta.label}
        {station.issueCount > 0 && ` · ${station.issueCount} issue${station.issueCount > 1 ? "s" : ""}`}
      </span>

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
            <dd className="font-medium text-slate-800">{latest.ph ?? "—"}</dd>
          </div>
          <div>
            <dt className="text-slate-400">DO (mg/L)</dt>
            <dd className="font-medium text-slate-800">{latest.dissolved_oxygen_mg_l ?? "—"}</dd>
          </div>
          <div>
            <dt className="text-slate-400">BOD (mg/L)</dt>
            <dd className="font-medium text-slate-800">{latest.bod_mg_l ?? "—"}</dd>
          </div>
          <div>
            <dt className="text-slate-400">Turbidity</dt>
            <dd className="font-medium text-slate-800">{latest.turbidity_ntu ?? "—"}</dd>
          </div>
        </dl>
      ) : (
        <p className="mt-2.5 text-xs text-slate-500">No recent readings</p>
      )}

      <Link
        href={`/stations/${station.id}`}
        className="mt-3 flex items-center justify-center gap-1 rounded-lg bg-cyan-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-cyan-700"
      >
        View history →
      </Link>
    </div>
  );
}
