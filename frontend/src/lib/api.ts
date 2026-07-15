import type { Deficiency, Reading, ScrapeResult, Station } from "./types";

export class ApiError extends Error {
  status: number;

  constructor(status: number, message: string) {
    super(message);
    this.status = status;
  }
}

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`/api/proxy${path}`, init);
  if (!res.ok) {
    const body = await res.text().catch(() => "");
    throw new ApiError(res.status, body || res.statusText);
  }
  return res.json() as Promise<T>;
}

export const api = {
  stations: () => request<Station[]>("/stations"),

  latestReadings: (stationId?: number) =>
    request<Reading[]>(`/readings/latest${stationId ? `?station_id=${stationId}` : ""}`),

  readingsHistory: (stationId: number, days = 30) =>
    request<Reading[]>(`/readings/history?station_id=${stationId}&days=${days}`),

  deficiency: () => request<Deficiency[]>("/deficiency"),

  triggerScrape: (demo = true) =>
    request<ScrapeResult>(`/scrape?demo=${demo}`, { method: "POST" }),
};
