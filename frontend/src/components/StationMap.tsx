"use client";

import { useMemo, useState } from "react";
import Map, { Marker, Popup } from "react-map-gl/mapbox";
import Link from "next/link";
import "mapbox-gl/dist/mapbox-gl.css";
import { MAPBOX_TOKEN } from "@/lib/config";
import { statusColor } from "@/lib/status";
import type { Reading, Station } from "@/lib/types";

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

  if (!MAPBOX_TOKEN) {
    return (
      <div className="flex-1 grid place-items-center px-4">
        <p className="text-sm text-slate-400 max-w-sm text-center">
          Set <code className="text-slate-300">NEXT_PUBLIC_MAPBOX_TOKEN</code> in{" "}
          <code className="text-slate-300">frontend/.env.local</code> to enable the map.
        </p>
      </div>
    );
  }

  return (
    <Map
      mapboxAccessToken={MAPBOX_TOKEN}
      initialViewState={{ longitude: 82.5, latitude: 26, zoom: 5 }}
      style={{ flex: 1 }}
      mapStyle="mapbox://styles/mapbox/dark-v11"
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
          closeOnClick={false}
          anchor="bottom"
        >
          <div className="text-slate-900 text-sm space-y-1 min-w-40">
            <p className="font-medium">{selected.name}</p>
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
