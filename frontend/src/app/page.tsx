"use client";

import useSWR from "swr";
import { useMemo, useState } from "react";
import { ParamInfoPanel } from "@/components/ParamInfoPanel";
import { StationMap } from "@/components/StationMap";
import { api } from "@/lib/api";
import { readingIssues, severityOf, SEVERITY_META, STANDARD_RANGES } from "@/lib/status";
import type { Severity } from "@/lib/status";
import type { Reading } from "@/lib/types";

export default function HomePage() {
  const [river, setRiver] = useState<string>("");

  const stationsQuery = useSWR("stations", () => api.stations());
  const riversQuery = useSWR("rivers", () => api.rivers());
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

  const stations = useMemo(
    () => (stationsQuery.data ?? []).filter((s) => !river || s.river === river),
    [stationsQuery.data, river],
  );

  const counts = useMemo(() => {
    const c: Record<Severity, number> = { good: 0, warning: 0, critical: 0 };
    for (const station of stations) {
      const entry = readingsByStation.get(station.id);
      c[severityOf(entry?.issueCount ?? 0)] += 1;
    }
    return c;
  }, [stations, readingsByStation]);

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
          <button
            type="button"
            onClick={() => stationsQuery.mutate()}
            className="mt-4 inline-flex h-9 items-center rounded-lg bg-red-600 px-4 text-sm font-medium text-white hover:bg-red-700"
          >
            Retry
          </button>
        </div>
      </div>
    );
  }

  const total = stations.length;

  return (
    <div className="flex-1 flex flex-col md:relative">
      {/* Station status summary + parameter info, stacked on the left */}
      <div className="md:absolute md:top-4 md:left-4 md:z-10 md:w-56 md:flex md:max-h-[calc(100vh-6rem)] md:flex-col md:gap-3 md:overflow-y-auto">
        <div className="mx-4 mt-4 md:mx-0 md:mt-0 rounded-2xl border border-cyan-100 bg-white/90 backdrop-blur-sm p-4 shadow-lg shadow-cyan-900/5">
          <div className="flex items-baseline justify-between">
            <h2 className="text-sm font-semibold text-slate-900">Stations</h2>
            <span className="text-xs text-slate-400">{total} total</span>
          </div>

          <label className="mt-3 block">
            <span className="sr-only">Filter by river</span>
            <select
              value={river}
              onChange={(e) => setRiver(e.target.value)}
              className="w-full rounded-lg border border-cyan-200 bg-white px-2.5 py-2 text-sm text-slate-700 focus:border-cyan-400 focus:outline-none focus:ring-2 focus:ring-cyan-100"
            >
              <option value="">All rivers</option>
              {(riversQuery.data ?? []).map((r) => (
                <option key={r} value={r}>
                  {r}
                </option>
              ))}
            </select>
          </label>

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

        <ParamInfoPanel className="mx-4 mt-3 md:mx-0 md:mt-0" />
      </div>

      {/* Standard ranges reference */}
      <details className="mx-4 mt-3 md:absolute md:top-4 md:right-4 md:z-10 md:mx-0 md:mt-0 md:w-56 group rounded-2xl border border-cyan-100 bg-white/90 backdrop-blur-sm p-4 shadow-lg shadow-cyan-900/5 md:open:pb-4" open>
        <summary className="flex cursor-pointer list-none items-center justify-between text-sm font-semibold text-slate-900 md:pointer-events-none">
          Standard ranges
          <svg
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden
            className="h-4 w-4 text-slate-400 transition-transform group-open:rotate-180 md:hidden"
          >
            <path fillRule="evenodd" d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z" clipRule="evenodd" />
          </svg>
        </summary>
        <dl className="mt-3 space-y-1.5 text-sm">
          {STANDARD_RANGES.map((r) => (
            <div key={r.label} className="flex items-center justify-between gap-4">
              <dt className="text-slate-600">{r.label}</dt>
              <dd className="font-medium text-slate-500 tabular-nums">{r.range}</dd>
            </div>
          ))}
        </dl>
      </details>

      <div className="mt-3 md:mt-0 flex flex-col flex-1 min-h-[280px]">
        <StationMap stations={stations} readingsByStation={readingsByStation} />
      </div>
    </div>
  );
}
