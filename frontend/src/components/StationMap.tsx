"use client";

import { useMemo, useState } from "react";
import Map, { Marker, Popup } from "react-map-gl/maplibre";
import Link from "next/link";
import "maplibre-gl/dist/maplibre-gl.css";
import { statusColor } from "@/lib/status";
import type { Reading, Station } from "@/lib/types";

// Free, keyless vector basemap — CARTO's CDN-backed style, built for
// unlimited public use (unlike raw OSM tiles, which rate-limit automated
// traffic per their usage policy).
const BASEMAP_STYLE = "https://basemaps.cartocdn.com/gl/positron-gl-style/style.json";

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
      {points.map((s) => (
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
            aria-label={s.name}
            className="h-3.5 w-3.5 rounded-full border-2 border-slate-950 cursor-pointer"
            style={{ backgroundColor: statusColor(s.issueCount) }}
          />
        </Marker>
      ))}

      {selected && selected.latitude !== null && selected.longitude !== null && (
        <Popup
          longitude={selected.longitude}
          latitude={selected.latitude}
          onClose={() => setSelected(null)}
          closeButton={false}
          closeOnClick={false}
          anchor="bottom"
        >
          <div className="text-slate-900 text-sm space-y-1 min-w-40 pr-1">
            <div className="flex items-start justify-between gap-2">
              <p className="font-medium">{selected.name}</p>
              <button
                type="button"
                aria-label="Close"
                onClick={() => setSelected(null)}
                className="text-slate-400 hover:text-slate-700 leading-none text-base -mt-0.5"
              >
                ×
              </button>
            </div>
            <p className="text-slate-600">{selected.river} · {selected.location}</p>
            {selected.latest ? (
              <p className="text-xs text-slate-500">
                pH {selected.latest.ph ?? "—"} · DO {selected.latest.dissolved_oxygen_mg_l ?? "—"} mg/L
              </p>
            ) : (
              <p className="text-xs text-slate-500">No recent readings</p>
            )}
            <Link href={`/stations/${selected.id}`} className="text-cyan-600 hover:underline text-xs">
              View history →
            </Link>
          </div>
        </Popup>
      )}
    </Map>
  );
}
