"use client";

import { useState } from "react";
import { PARAM_GUIDES } from "@/lib/paramGuide";

export function ParamInfoPanel({ className = "" }: { className?: string }) {
  const [expanded, setExpanded] = useState<Record<string, boolean>>({});
  const toggle = (key: string) => setExpanded((prev) => ({ ...prev, [key]: !prev[key] }));

  return (
    <div
      className={`rounded-2xl border border-cyan-100 bg-white/90 backdrop-blur-sm p-4 shadow-lg shadow-cyan-900/5 ${className}`}
    >
      <h2 className="text-sm font-semibold text-slate-900">Info</h2>
      <p className="mt-0.5 text-xs text-slate-500">What each reading means and why it matters.</p>

      <div className="mt-3 space-y-3">
        {PARAM_GUIDES.map((p) => (
          <div key={p.key}>
            <p className="text-xs font-semibold text-slate-800">{p.label}</p>
            <p className="mt-0.5 text-xs text-slate-600">{p.short}</p>
            {expanded[p.key] && (
              <p className="mt-1.5 rounded-lg bg-cyan-50/70 p-2 text-xs leading-relaxed text-slate-600">
                {p.body}
              </p>
            )}
            <button
              type="button"
              onClick={() => toggle(p.key)}
              className="mt-1 text-xs font-medium text-cyan-700 hover:text-cyan-800"
            >
              {expanded[p.key] ? "Show less" : "Read more"}
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
