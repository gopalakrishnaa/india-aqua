import type { Reading } from "./types";

export type Severity = "good" | "warning" | "critical";

// CPCB-style bathing water thresholds (simplified).
export const STANDARD_RANGES = [
  { label: "pH", range: "6.5 – 8.5" },
  { label: "Dissolved oxygen", range: "≥ 4 mg/L" },
  { label: "BOD", range: "≤ 3 mg/L" },
  { label: "Turbidity", range: "≤ 10 NTU" },
];

export function readingIssues(reading: Reading): string[] {
  const issues: string[] = [];
  if (reading.ph !== null && (reading.ph < 6.5 || reading.ph > 8.5)) {
    issues.push("pH out of range");
  }
  if (reading.dissolved_oxygen_mg_l !== null && reading.dissolved_oxygen_mg_l < 4) {
    issues.push("Low dissolved oxygen");
  }
  if (reading.bod_mg_l !== null && reading.bod_mg_l > 3) {
    issues.push("High BOD");
  }
  if (reading.turbidity_ntu !== null && reading.turbidity_ntu > 10) {
    issues.push("High turbidity");
  }
  return issues;
}

export function severityOf(issueCount: number): Severity {
  if (issueCount === 0) return "good";
  if (issueCount === 1) return "warning";
  return "critical";
}

export const SEVERITY_META: Record<
  Severity,
  { label: string; hex: string; dot: string; text: string; pill: string }
> = {
  good: {
    label: "Healthy",
    hex: "#10b981",
    dot: "bg-emerald-500",
    text: "text-emerald-700",
    pill: "bg-emerald-50 text-emerald-700 ring-1 ring-emerald-200",
  },
  warning: {
    label: "Warning",
    hex: "#f59e0b",
    dot: "bg-amber-500",
    text: "text-amber-700",
    pill: "bg-amber-50 text-amber-700 ring-1 ring-amber-200",
  },
  critical: {
    label: "Critical",
    hex: "#ef4444",
    dot: "bg-red-500",
    text: "text-red-700",
    pill: "bg-red-50 text-red-700 ring-1 ring-red-200",
  },
};

export function statusColor(issueCount: number): string {
  return SEVERITY_META[severityOf(issueCount)].hex;
}
