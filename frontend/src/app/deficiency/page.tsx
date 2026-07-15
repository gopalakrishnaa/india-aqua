"use client";

import useSWR from "swr";
import Link from "next/link";
import { CredentialsGate } from "@/components/CredentialsGate";
import { useCredentials } from "@/lib/useCredentials";
import { api } from "@/lib/api";

function DeficiencyTable() {
  const { baseUrl, apiKey } = useCredentials();
  const { data, error, isLoading } = useSWR(
    apiKey ? ["deficiency", baseUrl, apiKey] : null,
    () => api.deficiency(baseUrl, apiKey),
    { refreshInterval: 60_000 },
  );

  if (isLoading) return <p className="text-slate-500 text-sm">Loading…</p>;
  if (error) return <p className="text-red-400 text-sm">Failed to load deficiency report.</p>;
  if (!data || data.length === 0) {
    return <p className="text-slate-500 text-sm">No deficient stations — all readings within range.</p>;
  }

  return (
    <div className="overflow-x-auto rounded-lg border border-slate-800">
      <table className="w-full text-sm text-left">
        <thead className="bg-slate-900 text-slate-400">
          <tr>
            <th className="px-4 py-2 font-medium">Station</th>
            <th className="px-4 py-2 font-medium">Location</th>
            <th className="px-4 py-2 font-medium">Issues</th>
            <th className="px-4 py-2 font-medium">Last reading</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-slate-800">
          {data.map((d) => (
            <tr key={d.station_id} className="hover:bg-slate-900/60">
              <td className="px-4 py-2">
                <Link href={`/stations/${d.station_id}`} className="text-cyan-400 hover:underline">
                  {d.station_name}
                </Link>
              </td>
              <td className="px-4 py-2 text-slate-400">{d.location}</td>
              <td className="px-4 py-2">
                <div className="flex flex-wrap gap-1">
                  {d.issues.map((issue) => (
                    <span
                      key={issue}
                      className="rounded-full bg-red-500/10 text-red-400 px-2 py-0.5 text-xs"
                    >
                      {issue}
                    </span>
                  ))}
                </div>
              </td>
              <td className="px-4 py-2 text-slate-400">{d.last_reading_at ?? "—"}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default function DeficiencyPage() {
  return (
    <div className="mx-auto max-w-4xl w-full px-4 py-8 space-y-4 flex-1">
      <h1 className="text-xl font-semibold text-slate-100">Deficiency report</h1>
      <CredentialsGate>
        <DeficiencyTable />
      </CredentialsGate>
    </div>
  );
}
