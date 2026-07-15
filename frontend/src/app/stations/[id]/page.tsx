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
import { CredentialsGate } from "@/components/CredentialsGate";
import { useCredentials } from "@/lib/useCredentials";
import { api } from "@/lib/api";
import type { Reading } from "@/lib/types";

const METRICS: { key: keyof Reading; label: string; unit: string; color: string }[] = [
  { key: "ph", label: "pH", unit: "", color: "#38bdf8" },
  { key: "dissolved_oxygen_mg_l", label: "Dissolved oxygen", unit: "mg/L", color: "#22c55e" },
  { key: "bod_mg_l", label: "BOD", unit: "mg/L", color: "#f97316" },
  { key: "cod_mg_l", label: "COD", unit: "mg/L", color: "#a855f7" },
  { key: "turbidity_ntu", label: "Turbidity", unit: "NTU", color: "#eab308" },
];

function StationDetail({ stationId }: { stationId: number }) {
  const { baseUrl, apiKey } = useCredentials();
  const { data, error, isLoading } = useSWR(
    apiKey ? ["history", baseUrl, apiKey, stationId] : null,
    () => api.readingsHistory(baseUrl, apiKey, stationId, 30),
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
        <Link href="/" className="text-sm text-cyan-400 hover:underline">
          ← Back to map
        </Link>
        <h1 className="text-xl font-semibold text-slate-100 mt-2">{stationName}</h1>
        <p className="text-sm text-slate-500">Last 30 days</p>
      </div>

      {isLoading && <p className="text-slate-500 text-sm">Loading…</p>}
      {error && <p className="text-red-400 text-sm">Failed to load history.</p>}
      {!isLoading && !error && chartData.length === 0 && (
        <p className="text-slate-500 text-sm">No readings recorded for this station yet.</p>
      )}

      {chartData.length > 0 && (
        <div className="grid gap-6 sm:grid-cols-2">
          {METRICS.map((metric) => (
            <div key={metric.key} className="rounded-lg border border-slate-800 p-4">
              <h3 className="text-sm font-medium text-slate-300 mb-2">
                {metric.label} {metric.unit && <span className="text-slate-500">({metric.unit})</span>}
              </h3>
              <ResponsiveContainer width="100%" height={200}>
                <LineChart data={chartData}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#1e293b" />
                  <XAxis dataKey="recorded_at" stroke="#64748b" fontSize={11} />
                  <YAxis stroke="#64748b" fontSize={11} domain={["auto", "auto"]} />
                  <Tooltip
                    contentStyle={{ background: "#0f172a", border: "1px solid #1e293b", fontSize: 12 }}
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

export default function StationPage() {
  const params = useParams<{ id: string }>();
  const stationId = Number(params.id);

  return (
    <CredentialsGate>
      <StationDetail stationId={stationId} />
    </CredentialsGate>
  );
}
