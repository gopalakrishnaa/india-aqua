"use client";

import useSWR from "swr";
import Link from "next/link";
import { useParams } from "next/navigation";
import {
  CartesianGrid,
  Line,
  LineChart,
  ReferenceLine,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import { api } from "@/lib/api";
import { readingIssues, severityOf, SEVERITY_META } from "@/lib/status";
import type { Reading } from "@/lib/types";

type Metric = {
  key: keyof Reading;
  label: string;
  unit: string;
  color: string;
  refs?: { value: number; label: string }[];
};

const METRICS: Metric[] = [
  { key: "ph", label: "pH", unit: "", color: "#0ea5e9", refs: [{ value: 6.5, label: "min" }, { value: 8.5, label: "max" }] },
  { key: "dissolved_oxygen_mg_l", label: "Dissolved oxygen", unit: "mg/L", color: "#10b981", refs: [{ value: 4, label: "min" }] },
  { key: "bod_mg_l", label: "BOD", unit: "mg/L", color: "#f97316", refs: [{ value: 3, label: "max" }] },
  { key: "cod_mg_l", label: "COD", unit: "mg/L", color: "#a855f7" },
  { key: "turbidity_ntu", label: "Turbidity", unit: "NTU", color: "#eab308", refs: [{ value: 10, label: "max" }] },
];

export default function StationPage() {
  const params = useParams<{ id: string }>();
  const stationId = Number(params.id);

  const { data, error, isLoading, mutate } = useSWR(["history", stationId], () =>
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

  const latest = data?.[0] ?? null;
  const stationName = latest?.station_name ?? `Station ${stationId}`;
  const meta = latest ? SEVERITY_META[severityOf(readingIssues(latest).length)] : null;

  return (
    <div className="mx-auto max-w-5xl w-full px-4 py-8 space-y-6 flex-1">
      <div>
        <Link
          href="/"
          className="inline-flex items-center gap-1 text-sm text-cyan-700 hover:text-cyan-800 hover:underline"
        >
          ← Back to map
        </Link>
        <div className="mt-3 flex flex-wrap items-center gap-3">
          <h1 className="text-2xl font-semibold tracking-tight text-slate-900">{stationName}</h1>
          {meta && (
            <span
              className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-xs font-medium ${meta.pill}`}
            >
              <span className={`h-1.5 w-1.5 rounded-full ${meta.dot}`} />
              {meta.label}
            </span>
          )}
        </div>
        <p className="mt-1 text-sm text-slate-500">Last 30 days of readings</p>
      </div>

      {isLoading && (
        <div className="grid place-items-center py-16">
          <span className="h-8 w-8 rounded-full border-2 border-cyan-200 border-t-cyan-600 animate-spin" />
        </div>
      )}
      {error && (
        <div className="rounded-2xl border border-red-100 bg-red-50/70 p-6 text-sm text-red-700">
          <p>Couldn&apos;t load reading history.</p>
          <button
            type="button"
            onClick={() => mutate()}
            className="mt-3 inline-flex h-9 items-center rounded-lg bg-red-600 px-4 text-sm font-medium text-white hover:bg-red-700"
          >
            Retry
          </button>
        </div>
      )}
      {!isLoading && !error && chartData.length === 0 && (
        <div className="rounded-2xl border border-cyan-100 bg-white p-6 text-sm text-slate-500">
          No readings recorded for this station yet.
        </div>
      )}

      {latest?.wqi != null && (
        <div className="flex flex-wrap items-center gap-x-6 gap-y-2 rounded-2xl border border-cyan-100 bg-gradient-to-br from-cyan-50 to-white p-5 shadow-sm shadow-cyan-900/5">
          <div>
            <p className="text-xs uppercase tracking-wide text-slate-400">Water Quality Index</p>
            <p className="mt-1 flex items-baseline gap-2">
              <span className="text-4xl font-semibold text-slate-900 tabular-nums">{latest.wqi}</span>
              <span className="text-sm text-slate-400">/ 100</span>
            </p>
          </div>
          {latest.quality_class && (
            <span className="rounded-full bg-white px-3 py-1 text-sm font-medium text-cyan-700 ring-1 ring-cyan-200">
              {latest.quality_class}
            </span>
          )}
        </div>
      )}

      {latest && (
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-6">
          {[
            { label: "pH", value: latest.ph },
            { label: "DO", value: latest.dissolved_oxygen_mg_l, unit: "mg/L" },
            { label: "BOD", value: latest.bod_mg_l, unit: "mg/L" },
            { label: "COD", value: latest.cod_mg_l, unit: "mg/L" },
            { label: "Turbidity", value: latest.turbidity_ntu, unit: "NTU" },
            { label: "Temp", value: latest.temperature_c, unit: "°C" },
          ].map((s) => (
            <div key={s.label} className="rounded-xl border border-cyan-100 bg-white p-3">
              <p className="text-xs text-slate-400">{s.label}</p>
              <p className="mt-0.5 text-lg font-semibold text-slate-900 tabular-nums">
                {s.value ?? "N/A"}
                {s.value !== null && s.unit ? (
                  <span className="ml-1 text-xs font-normal text-slate-400">{s.unit}</span>
                ) : null}
              </p>
            </div>
          ))}
        </div>
      )}

      {chartData.length > 0 && (
        <div className="grid gap-4 sm:grid-cols-2">
          {METRICS.map((metric) => (
            <div key={metric.key} className="rounded-2xl border border-cyan-100 bg-white p-4 shadow-sm shadow-cyan-900/5">
              <h3 className="text-sm font-medium text-slate-700 mb-3">
                {metric.label}{" "}
                {metric.unit && <span className="text-slate-400">({metric.unit})</span>}
              </h3>
              <ResponsiveContainer width="100%" height={200}>
                <LineChart data={chartData} margin={{ top: 4, right: 8, bottom: 0, left: -12 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#e0f2fe" />
                  <XAxis dataKey="recorded_at" stroke="#94a3b8" fontSize={11} tickLine={false} />
                  <YAxis stroke="#94a3b8" fontSize={11} tickLine={false} axisLine={false} domain={["auto", "auto"]} />
                  <Tooltip
                    contentStyle={{
                      background: "#fff",
                      border: "1px solid #a5f3fc",
                      borderRadius: 10,
                      fontSize: 12,
                      boxShadow: "0 8px 24px -8px rgb(8 47 73 / 0.2)",
                    }}
                  />
                  {metric.refs?.map((ref) => (
                    <ReferenceLine
                      key={ref.label}
                      y={ref.value}
                      stroke="#f43f5e"
                      strokeDasharray="4 4"
                      strokeOpacity={0.5}
                    />
                  ))}
                  <Line
                    type="monotone"
                    dataKey={metric.key}
                    stroke={metric.color}
                    strokeWidth={2}
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
