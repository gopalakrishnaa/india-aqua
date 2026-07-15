"use client";

import useSWR from "swr";
import Link from "next/link";
import { api } from "@/lib/api";

export default function DeficiencyPage() {
  const { data, error, isLoading } = useSWR("deficiency", () => api.deficiency(), {
    refreshInterval: 60_000,
  });

  return (
    <div className="mx-auto max-w-4xl w-full px-4 py-8 space-y-4 flex-1">
      <h1 className="text-xl font-semibold text-slate-900">Deficiency report</h1>

      {isLoading && <p className="text-slate-500 text-sm">Loading…</p>}
      {error && <p className="text-red-600 text-sm">Failed to load deficiency report.</p>}
      {!isLoading && !error && (!data || data.length === 0) && (
        <p className="text-slate-500 text-sm">No deficient stations — all readings within range.</p>
      )}

      {data && data.length > 0 && (
        <div className="overflow-x-auto rounded-lg border border-cyan-200">
          <table className="w-full text-sm text-left">
            <thead className="bg-cyan-100 text-slate-600">
              <tr>
                <th className="px-4 py-2 font-medium">Station</th>
                <th className="px-4 py-2 font-medium">Location</th>
                <th className="px-4 py-2 font-medium">Issues</th>
                <th className="px-4 py-2 font-medium">Last reading</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-cyan-100 bg-white">
              {data.map((d) => (
                <tr key={d.station_id} className="hover:bg-cyan-50">
                  <td className="px-4 py-2">
                    <Link href={`/stations/${d.station_id}`} className="text-cyan-700 hover:underline">
                      {d.station_name}
                    </Link>
                  </td>
                  <td className="px-4 py-2 text-slate-500">{d.location}</td>
                  <td className="px-4 py-2">
                    <div className="flex flex-wrap gap-1">
                      {d.issues.map((issue) => (
                        <span
                          key={issue}
                          className="rounded-full bg-red-100 text-red-700 px-2 py-0.5 text-xs"
                        >
                          {issue}
                        </span>
                      ))}
                    </div>
                  </td>
                  <td className="px-4 py-2 text-slate-500">{d.last_reading_at ?? "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
