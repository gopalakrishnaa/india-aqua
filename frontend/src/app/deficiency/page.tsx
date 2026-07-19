"use client";

import useSWR from "swr";
import Link from "next/link";
import { api } from "@/lib/api";
import { SEVERITY_META, severityOf } from "@/lib/status";

export default function DeficiencyPage() {
  const { data, error, isLoading, mutate } = useSWR("deficiency", () => api.deficiency(), {
    refreshInterval: 60_000,
  });

  return (
    <div className="mx-auto max-w-4xl w-full px-4 py-8 space-y-5 flex-1">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight text-slate-900">Deficiency report</h1>
        <p className="mt-1 text-sm text-slate-500">
          Stations with readings outside standard water-quality ranges.
        </p>
      </div>

      {isLoading && (
        <div className="grid place-items-center py-16">
          <span className="h-8 w-8 rounded-full border-2 border-cyan-200 border-t-cyan-600 animate-spin" />
        </div>
      )}
      {error && (
        <div className="rounded-2xl border border-red-100 bg-red-50/70 p-6 text-sm text-red-700">
          <p>Couldn&apos;t load the deficiency report.</p>
          <button
            type="button"
            onClick={() => mutate()}
            className="mt-3 inline-flex h-9 items-center rounded-lg bg-red-600 px-4 text-sm font-medium text-white hover:bg-red-700"
          >
            Retry
          </button>
        </div>
      )}
      {!isLoading && !error && (!data || data.length === 0) && (
        <div className="rounded-2xl border border-emerald-100 bg-emerald-50/60 p-8 text-center">
          <p className="font-medium text-emerald-800">All clear</p>
          <p className="mt-1 text-sm text-emerald-600">
            Every station is reading within standard ranges.
          </p>
        </div>
      )}

      {data && data.length > 0 && (
        <div className="overflow-x-auto rounded-2xl border border-cyan-100 bg-white shadow-sm shadow-cyan-900/5">
          <table className="w-full min-w-[560px] text-sm text-left">
            <thead className="bg-cyan-50/80 text-slate-500">
              <tr>
                <th className="px-4 py-3 font-medium">Station</th>
                <th className="px-4 py-3 font-medium">Location</th>
                <th className="px-4 py-3 font-medium">Issues</th>
                <th className="px-4 py-3 font-medium whitespace-nowrap">Last reading</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-cyan-50">
              {data.map((d) => {
                const meta = SEVERITY_META[severityOf(d.issues.length)];
                return (
                  <tr key={d.station_id} className="hover:bg-cyan-50/50 transition-colors">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-2">
                        <span className={`h-2 w-2 rounded-full ${meta.dot}`} />
                        <Link
                          href={`/stations/${d.station_id}`}
                          className="font-medium text-cyan-700 hover:text-cyan-800 hover:underline"
                        >
                          {d.station_name}
                        </Link>
                      </div>
                    </td>
                    <td className="px-4 py-3 text-slate-500">{d.location}</td>
                    <td className="px-4 py-3">
                      <div className="flex flex-wrap gap-1">
                        {d.issues.map((issue) => (
                          <span
                            key={issue}
                            className="rounded-full bg-red-50 px-2 py-0.5 text-xs font-medium text-red-700 ring-1 ring-red-100"
                          >
                            {issue}
                          </span>
                        ))}
                      </div>
                    </td>
                    <td className="px-4 py-3 text-slate-500 whitespace-nowrap">
                      {d.last_reading_at ?? "N/A"}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
