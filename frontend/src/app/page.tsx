"use client";

import useSWR from "swr";
import { useMemo } from "react";
import { StationMap } from "@/components/StationMap";
import { api } from "@/lib/api";
import { readingIssues, severityOf, SEVERITY_META, STANDARD_RANGES } from "@/lib/status";
import type { Severity } from "@/lib/status";
import type { Reading } from "@/lib/types";

export default function HomePage() {
  const stationsQuery = useSWR("stations", () => api.stations());
  const readingsQuery = useSWR("latest-readings", () => api.latestReadings(), {
    refreshInterval: 60_000,
  });

  const readingsByStation = useMemo(() => {
    const map = new Map<number, { reading: Reading; issueCount: number }>();
    for (const reading of readingsQuery.data ?? []) {
      map.set(reading.station_id, { reading, issueCount: readingIssues(reading).length });
    }
    return map;
  }, [readingsQuery.data]);

  const counts = useMemo(() => {
    const c: Record<Severity, number> = { good: 0, warning: 0, critical: 0 };
    for (const station of stationsQuery.data ?? []) {
      const entry = readingsByStation.get(station.id);
      c[severityOf(entry?.issueCount ?? 0)] += 1;
    }
    return c;
  }, [stationsQuery.data, readingsByStation]);

  if (stationsQuery.isLoading) {
    return (
      <div className="flex-1 grid place-items-center">
        <div className="flex flex-col items-center gap-3 text-slate-500">
          <span className="h-8 w-8 rounded-full border-2 border-cyan-200 border-t-cyan-600 animate-spin" />
          <p className="text-sm">Loading stations…</p>
        </div>
      </div>
    );
  }
  if (stationsQuery.error) {
    return (
      <div className="flex-1 grid place-items-center px-4">
        <div className="max-w-sm rounded-2xl border border-red-100 bg-red-50/70 p-6 text-center">
          <p className="font-medium text-red-800">Couldn&apos;t load stations</p>
          <p className="mt-1 text-sm text-red-600">Check that the backend API is running.</p>
        </div>
      </div>
    );
  }

  const total = stationsQuery.data?.length ?? 0;

  return (
    <div className="flex-1 flex flex-col relative">
      {/* Station status summary */}
      <div className="absolute top-4 left-4 z-10 w-56 rounded-2xl border border-cyan-100 bg-white/90 backdrop-blur-sm p-4 shadow-lg shadow-cyan-900/5">
        <div className="flex items-baseline justify-between">
          <h2 className="text-sm font-semibold text-slate-900">Stations</h2>
          <span className="text-xs text-slate-400">{total} total</span>
        </div>
        <div className="mt-3 space-y-2">
          {(["good", "warning", "critical"] as Severity[]).map((sev) => {
            const meta = SEVERITY_META[sev];
            return (
              <div key={sev} className="flex items-center gap-2.5">
                <span className={`h-2.5 w-2.5 rounded-full ${meta.dot}`} />
                <span className="flex-1 text-sm text-slate-600">{meta.label}</span>
                <span className="text-sm font-semibold text-slate-900 tabular-nums">
                  {counts[sev]}
                </span>
              </div>
            );
          })}
        </div>
      </div>

      {/* Standard ranges reference */}
      <div className="absolute top-4 right-4 z-10 w-56 rounded-2xl border border-cyan-100 bg-white/90 backdrop-blur-sm p-4 shadow-lg shadow-cyan-900/5">
        <h2 className="text-sm font-semibold text-slate-900">Standard ranges</h2>
        <dl className="mt-3 space-y-1.5 text-sm">
          {STANDARD_RANGES.map((r) => (
            <div key={r.label} className="flex items-center justify-between gap-4">
              <dt className="text-slate-600">{r.label}</dt>
              <dd className="font-medium text-slate-500 tabular-nums">{r.range}</dd>
            </div>
          ))}
        </dl>
      </div>

      <StationMap stations={stationsQuery.data ?? []} readingsByStation={readingsByStation} />
    </div>
  );
}
