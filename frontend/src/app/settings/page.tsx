"use client";

import { useState } from "react";
import { useCredentials } from "@/lib/useCredentials";
import { api, ApiError } from "@/lib/api";

export default function SettingsPage() {
  const { baseUrl, apiKey, setBaseUrl, setApiKey, ready } = useCredentials();
  const [status, setStatus] = useState<"idle" | "testing" | "ok" | "error">("idle");
  const [message, setMessage] = useState("");

  async function handleTest() {
    setStatus("testing");
    setMessage("");
    try {
      const stations = await api.stations(baseUrl, apiKey);
      setStatus("ok");
      setMessage(`Connected — ${stations.length} station(s) found.`);
    } catch (err) {
      setStatus("error");
      setMessage(err instanceof ApiError ? `${err.status}: ${err.message}` : "Connection failed");
    }
  }

  if (!ready) return null;

  return (
    <div className="mx-auto max-w-md w-full px-4 py-10 space-y-6">
      <div>
        <h1 className="text-xl font-semibold text-slate-100">Settings</h1>
        <p className="text-sm text-slate-400 mt-1">
          Stored only in this browser (localStorage) — never sent anywhere but the API base URL
          below.
        </p>
      </div>

      <label className="block space-y-1.5">
        <span className="text-sm font-medium text-slate-300">API base URL</span>
        <input
          value={baseUrl}
          onChange={(e) => setBaseUrl(e.target.value)}
          placeholder="http://localhost:8000"
          className="w-full rounded-md border border-slate-700 bg-slate-900 px-3 py-2 text-sm text-slate-100 focus:outline-none focus:ring-2 focus:ring-cyan-600"
        />
      </label>

      <label className="block space-y-1.5">
        <span className="text-sm font-medium text-slate-300">X-API-Key</span>
        <input
          value={apiKey}
          onChange={(e) => setApiKey(e.target.value)}
          type="password"
          placeholder="your api key"
          className="w-full rounded-md border border-slate-700 bg-slate-900 px-3 py-2 text-sm text-slate-100 focus:outline-none focus:ring-2 focus:ring-cyan-600"
        />
      </label>

      <button
        onClick={handleTest}
        disabled={!apiKey || status === "testing"}
        className="rounded-md bg-cyan-600 px-4 py-2 text-sm font-medium text-white hover:bg-cyan-500 disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {status === "testing" ? "Testing…" : "Test connection"}
      </button>

      {message && (
        <p className={`text-sm ${status === "ok" ? "text-cyan-400" : "text-red-400"}`}>
          {message}
        </p>
      )}
    </div>
  );
}
