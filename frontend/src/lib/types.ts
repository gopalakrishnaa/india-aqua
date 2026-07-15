export type Station = {
  id: number;
  name: string;
  river: string;
  location: string;
  latitude: number | null;
  longitude: number | null;
  cpcb_code: string | null;
};

export type Reading = {
  id: number;
  station_id: number;
  station_name: string | null;
  ph: number | null;
  dissolved_oxygen_mg_l: number | null;
  bod_mg_l: number | null;
  cod_mg_l: number | null;
  turbidity_ntu: number | null;
  temperature_c: number | null;
  recorded_at: string;
  source_url: string;
};

export type Deficiency = {
  station_id: number;
  station_name: string;
  location: string;
  issues: string[];
  last_reading_at: string | null;
};

export type ScrapeResult = {
  scraped: number;
  stored: number;
  rejected: number;
};
