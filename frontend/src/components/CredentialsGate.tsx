"use client";

import Link from "next/link";
import type { ReactNode } from "react";
import { useCredentials } from "@/lib/useCredentials";

export function CredentialsGate({ children }: { children: ReactNode }) {
  const { apiKey, ready } = useCredentials();

  if (!ready) {
    return <div className="flex-1 grid place-items-center text-slate-500">Loading…</div>;
  }

  if (!apiKey) {
    return (
      <div className="flex-1 grid place-items-center px-4">
        <div className="max-w-sm text-center space-y-3">
          <h2 className="text-lg font-medium text-slate-100">API key required</h2>
          <p className="text-sm text-slate-400">
            Enter your ganga-aqua API key in Settings to load live station data.
          </p>
          <Link
            href="/settings"
            className="inline-block rounded-md bg-cyan-600 px-4 py-2 text-sm font-medium text-white hover:bg-cyan-500"
          >
            Go to Settings
          </Link>
        </div>
      </div>
    );
  }

  return <>{children}</>;
}
