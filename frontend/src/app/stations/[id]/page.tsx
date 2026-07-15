"use client";

import useSWR from "swr";
import Link from "next/link";
import { useParams } from "next/navigation";
import {
  CartesianGrid,
  Line,
  LineChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import { api } from "@/lib/api";
import type { Reading } from "@/lib/types";

const METRICS: { key: keyof Reading; label: string; unit: string; color: string }[] = [
  { key: "ph", label: "pH", unit: "", color: "#38bdf8" },
  { key: "dissolved_oxygen_mg_l", label: "Dissolved oxygen", unit: "mg/L", color: "#22c55e" },
  { key: "bod_mg_l", label: "BOD", unit: "mg/L", color: "#f97316" },
  { key: "cod_mg_l", label: "COD", unit: "mg/L", color: "#a855f7" },
  { key: "turbidity_ntu", label: "Turbidity", unit: "NTU", color: "#eab308" },
];

export default function StationPage() {
  const params = useParams<{ id: string }>();
  const stationId = Number(params.id);

  const { data, error, isLoading } = useSWR(["history", stationId], () =>
    api.readingsHistory(stationId, 30),
  );

  const chartData = (data ?? [])
    .slice()
    .reverse()
    .map((r) => ({
      ...r,
      recorded_at: new Date(r.recorded_at).toLocaleDateString(undefined, {
        month: "short",
        day: "numeric",
      }),
    }));

  const stationName = data?.[0]?.station_name ?? `Station ${stationId}`;

  return (
    <div className="mx-auto max-w-4xl w-full px-4 py-8 space-y-6 flex-1">
      <div>
        <Link href="/" className="text-sm text-cyan-700 hover:underline">
          ← Back to map
        </Link>
        <h1 className="text-xl font-semibold text-slate-900 mt-2">{stationName}</h1>
        <p className="text-sm text-slate-500">Last 30 days</p>
      </div>

      {isLoading && <p className="text-slate-500 text-sm">Loading…</p>}
      {error && <p className="text-red-600 text-sm">Failed to load history.</p>}
      {!isLoading && !error && chartData.length === 0 && (
        <p className="text-slate-500 text-sm">No readings recorded for this station yet.</p>
      )}

      {chartData.length > 0 && (
        <div className="grid gap-6 sm:grid-cols-2">
          {METRICS.map((metric) => (
            <div key={metric.key} className="rounded-lg border border-cyan-200 bg-white p-4">
              <h3 className="text-sm font-medium text-slate-700 mb-2">
                {metric.label} {metric.unit && <span className="text-slate-500">({metric.unit})</span>}
              </h3>
              <ResponsiveContainer width="100%" height={200}>
                <LineChart data={chartData}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#e0f2fe" />
                  <XAxis dataKey="recorded_at" stroke="#64748b" fontSize={11} />
                  <YAxis stroke="#64748b" fontSize={11} domain={["auto", "auto"]} />
                  <Tooltip
                    contentStyle={{ background: "#fff", border: "1px solid #a5f3fc", fontSize: 12 }}
                  />
                  <Line
                    type="monotone"
                    dataKey={metric.key}
                    stroke={metric.color}
                    dot={false}
                    connectNulls
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
