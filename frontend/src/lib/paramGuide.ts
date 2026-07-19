export type ParamGuide = {
  key: string;
  label: string;
  short: string;
  body: string;
};

export const PARAM_GUIDES: ParamGuide[] = [
  {
    key: "wqi",
    label: "WQI (Water Quality Index)",
    short: "A single 0-100 score summarizing overall water quality.",
    body: "The Water Quality Index rolls up pH, dissolved oxygen, BOD, COD, and turbidity into one number, so you can judge a station at a glance instead of reading five separate readings. Higher is better: 90+ is excellent, under 25 is unfit for most uses. Think of it as a report-card grade for the river at that spot.",
  },
  {
    key: "ph",
    label: "pH",
    short: "How acidic or alkaline the water is. Safe range is 6.5-8.5.",
    body: "pH measures acidity on a 0-14 scale, where 7 is neutral. The safe range for rivers is roughly 6.5-8.5. If pH climbs above 8.5, the water is too alkaline, which stresses fish gills and can trigger algae blooms. If it drops below 6.5, the water is too acidic, usually from industrial discharge or acid rain, which is toxic to fish eggs and aquatic insects. Both directions are unhealthy; it isn't a 'more is better' number.",
  },
  {
    key: "do",
    label: "Dissolved Oxygen (DO)",
    short: "Oxygen dissolved in the water that fish need to breathe.",
    body: "Fish and aquatic life breathe oxygen dissolved in the water itself. Healthy rivers hold at least 4-6 mg/L. When DO drops below that, fish suffocate and die off, often one of the first visible signs of pollution. Low DO usually means something is consuming the oxygen, commonly sewage or organic waste being broken down by bacteria. Here, more is better: there's no meaningful downside to a high reading.",
  },
  {
    key: "bod",
    label: "BOD (Biochemical Oxygen Demand)",
    short: "How much oxygen bacteria use up while decomposing waste in the water.",
    body: "BOD measures how much oxygen bacteria consume while breaking down organic pollution (sewage, food waste, plant matter) over 5 days. High BOD (above roughly 3 mg/L) means heavy organic waste is present, and the bacteria digesting it are stealing oxygen away from fish. It's an indirect pollution indicator: you're not measuring the pollution itself, you're measuring how hard the water is having to work to clean it up. Lower is better.",
  },
  {
    key: "cod",
    label: "COD (Chemical Oxygen Demand)",
    short: "Total oxygen needed to break down all pollutants, including ones bacteria can't digest.",
    body: "COD is BOD's stricter cousin: it measures the oxygen needed to chemically break down everything in the water, including industrial chemicals bacteria alone can't decompose (which BOD misses entirely). A COD reading much higher than BOD is a red flag for industrial or chemical contamination rather than plain sewage. Lower is better.",
  },
  {
    key: "turbidity",
    label: "Turbidity",
    short: "How cloudy the water is from suspended particles.",
    body: "Turbidity measures water clarity: how much silt, algae, or waste is suspended in it, making it look cloudy. High turbidity (above roughly 10 NTU) blocks sunlight from reaching underwater plants, can clog fish gills, and often carries bacteria and pathogens attached to the particles. Lower is clearer and healthier.",
  },
];
