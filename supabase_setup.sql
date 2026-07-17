-- india-aqua schema + seed for Supabase Postgres
-- Generated from the seeded demo DB. Safe to re-run: drops then recreates.

DROP TABLE IF EXISTS "water_quality_readings" CASCADE;
DROP TABLE IF EXISTS "validation_logs" CASCADE;
DROP TABLE IF EXISTS "saas_clients" CASCADE;
DROP TABLE IF EXISTS "monitoring_stations" CASCADE;

CREATE TABLE monitoring_stations (
	id SERIAL NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	river VARCHAR(100) NOT NULL, 
	location VARCHAR(200) NOT NULL, 
	latitude FLOAT, 
	longitude FLOAT, 
	cpcb_code VARCHAR(50), 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (cpcb_code)
);

CREATE TABLE saas_clients (
	id SERIAL NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	api_key_hash VARCHAR(128) NOT NULL, 
	tier VARCHAR(10) NOT NULL, 
	rate_limit VARCHAR(50) NOT NULL, 
	is_active BOOLEAN NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (api_key_hash)
);

CREATE TABLE validation_logs (
	id SERIAL NOT NULL, 
	station_id INTEGER, 
	raw_text TEXT NOT NULL, 
	extracted_json TEXT, 
	reason TEXT NOT NULL, 
	source_url VARCHAR(500) NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(station_id) REFERENCES monitoring_stations (id)
);

CREATE TABLE water_quality_readings (
	id SERIAL NOT NULL, 
	station_id INTEGER NOT NULL, 
	ph FLOAT, 
	dissolved_oxygen_mg_l FLOAT, 
	bod_mg_l FLOAT, 
	cod_mg_l FLOAT, 
	turbidity_ntu FLOAT, 
	temperature_c FLOAT, 
	wqi FLOAT, 
	quality_class VARCHAR(20), 
	recorded_at TIMESTAMP WITH TIME ZONE NOT NULL, 
	source_url VARCHAR(500) NOT NULL, 
	raw_text TEXT, 
	validated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(station_id) REFERENCES monitoring_stations (id)
);
CREATE INDEX ix_readings_station_recorded ON water_quality_readings (station_id, recorded_at);

-- monitoring_stations: 21 rows
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (1, 'Varanasi (Assi Ghat)', 'Ganga', 'Varanasi, Uttar Pradesh', 25.2867, 82.995, 'GNG-VNS-001', '2026-07-17 07:27:19');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (2, 'Kanpur (Jajmau)', 'Ganga', 'Kanpur, Uttar Pradesh', 26.4499, 80.3319, 'GNG-KNP-002', '2026-07-17 07:27:19');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (3, 'Haridwar (Har-Ki-Pauri)', 'Ganga', 'Haridwar, Uttarakhand', 29.9457, 78.1642, 'GNG-HRD-003', '2026-07-17 07:27:19');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (4, 'Patna (Digha Ghat)', 'Ganga', 'Patna, Bihar', 25.6093, 85.1235, 'GNG-PAT-004', '2026-07-17 07:27:19');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (5, 'Kolkata (Garden Reach)', 'Ganga', 'Kolkata, West Bengal', 22.5448, 88.3114, 'GNG-KOL-005', '2026-07-17 07:27:19');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (6, 'Delhi (ITO Bridge)', 'Yamuna', 'Delhi', 28.628, 77.2495, 'YMN-DEL-001', '2026-07-17 07:27:19');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (7, 'Mathura (Vishram Ghat)', 'Yamuna', 'Mathura, Uttar Pradesh', 27.4924, 77.6737, 'YMN-MTH-002', '2026-07-17 07:27:19');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (8, 'Agra (Taj Ghat)', 'Yamuna', 'Agra, Uttar Pradesh', 27.1751, 78.0421, 'YMN-AGR-003', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (9, 'Prayagraj (Sangam)', 'Yamuna', 'Prayagraj, Uttar Pradesh', 25.4225, 81.885, 'YMN-PRY-004', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (10, 'Nashik (Ramkund)', 'Godavari', 'Nashik, Maharashtra', 19.9975, 73.7898, 'GOD-NSK-001', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (11, 'Nanded', 'Godavari', 'Nanded, Maharashtra', 19.1383, 77.321, 'GOD-NDD-002', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (12, 'Rajahmundry', 'Godavari', 'Rajahmundry, Andhra Pradesh', 17.0005, 81.804, 'GOD-RJY-003', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (13, 'Sangli', 'Krishna', 'Sangli, Maharashtra', 16.8524, 74.5815, 'KRI-SGL-001', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (14, 'Vijayawada (Prakasam Barrage)', 'Krishna', 'Vijayawada, Andhra Pradesh', 16.5062, 80.648, 'KRI-VJA-002', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (15, 'Amaravati', 'Krishna', 'Amaravati, Andhra Pradesh', 16.573, 80.358, 'KRI-AMR-003', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (16, 'Jabalpur (Gwarighat)', 'Narmada', 'Jabalpur, Madhya Pradesh', 23.1815, 79.9864, 'NRM-JBP-001', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (17, 'Bharuch', 'Narmada', 'Bharuch, Gujarat', 21.7051, 72.9959, 'NRM-BRC-002', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (18, 'Srirangapatna', 'Cauvery', 'Mandya, Karnataka', 12.4111, 76.6935, 'CAU-SRP-001', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (19, 'Tiruchirappalli', 'Cauvery', 'Tiruchirappalli, Tamil Nadu', 10.7905, 78.7047, 'CAU-TRY-002', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (20, 'Guwahati', 'Brahmaputra', 'Guwahati, Assam', 26.1445, 91.7362, 'BRM-GHY-001', '2026-07-17 07:27:20');
INSERT INTO "monitoring_stations" ("id", "name", "river", "location", "latitude", "longitude", "cpcb_code", "created_at") VALUES (21, 'Dibrugarh', 'Brahmaputra', 'Dibrugarh, Assam', 27.4728, 94.912, 'BRM-DBR-002', '2026-07-17 07:27:20');

-- saas_clients: 1 rows
INSERT INTO "saas_clients" ("id", "name", "api_key_hash", "tier", "rate_limit", "is_active", "created_at") VALUES (1, 'bootstrap-admin', '2032850ea50723c850d400f4c366442757e3c8d129e432093e04f1c2ec49db82', 'ENTERPRISE', '1000/minute', true, '2026-07-17 07:27:20');

-- water_quality_readings: 630 rows
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (1, 1, 7.58, 7.45, 8.64, 36.33, 45.49, 20.75, 71.9, 'Moderate', '2026-07-16 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.58
DO: 7.45 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (2, 1, 8.22, 4.23, 3.21, 39.33, 101.66, 30.7, 53.8, 'Moderate', '2026-07-16 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 8.22
DO: 4.23 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (3, 1, 7.66, 3.66, 5.62, 9.44, 96.55, 31.9, 48.9, 'Poor', '2026-07-15 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.66
DO: 3.66 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (4, 1, 7.21, 7.4, 9.64, 5.68, 105.35, 19.41, 63.1, 'Moderate', '2026-07-13 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.21
DO: 7.4 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (5, 1, 7.68, 9.31, 8.99, 14.35, 114.55, 25.64, 64.4, 'Moderate', '2026-07-12 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.68
DO: 9.31 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (6, 1, 8.26, 2.93, 7.28, 9.73, 91.91, 21.9, 38.7, 'Poor', '2026-07-12 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 8.26
DO: 2.93 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (7, 1, 6.94, 8.3, 11.83, 34.32, 17.68, 30.22, 74.7, 'Moderate', '2026-07-11 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 6.94
DO: 8.3 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (8, 1, 8.37, 7.76, 4.97, 29.91, 36.54, 18.35, 78.9, 'Moderate', '2026-07-09 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 8.37
DO: 7.76 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (9, 1, 7.89, 5.3, 8.21, 11.24, 82.28, 22.32, 53.7, 'Moderate', '2026-07-08 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.89
DO: 5.3 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (10, 1, 6.98, 7.42, 9.98, 36.52, 42.34, 30.09, 72.1, 'Moderate', '2026-07-08 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 6.98
DO: 7.42 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (11, 1, 8.33, 7.63, 4.57, 27.09, 100.46, 24.13, 70.4, 'Moderate', '2026-07-06 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 8.33
DO: 7.63 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (12, 1, 7.44, 4.51, 9.14, 32.77, 15.91, 18.26, 58.5, 'Moderate', '2026-07-06 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.44
DO: 4.51 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (13, 1, 8.31, 2.53, 5.82, 25.22, 72.19, 29.87, 41.9, 'Poor', '2026-07-04 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 8.31
DO: 2.53 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (14, 1, 6.81, 3.71, 7.46, 18.03, 96.24, 25.47, 47.6, 'Poor', '2026-07-03 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 6.81
DO: 3.71 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (15, 1, 6.83, 9.02, 9.53, 22.57, 78.03, 30.19, 70.8, 'Moderate', '2026-07-03 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 6.83
DO: 9.02 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (16, 1, 8.38, 9.11, 3.17, 25.02, 79.22, 19.98, 78.2, 'Moderate', '2026-07-02 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 8.38
DO: 9.11 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (17, 1, 8.07, 2.03, 7.23, 6.0, 87.72, 26.81, 35.1, 'Poor', '2026-06-30 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 8.07
DO: 2.03 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (18, 1, 8.01, 2.45, 2.3, 14.18, 112.11, 28.68, 45.0, 'Poor', '2026-06-29 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 8.01
DO: 2.45 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (19, 1, 7.41, 3.0, 4.8, 27.74, 101.49, 26.06, 47.3, 'Poor', '2026-06-28 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.41
DO: 3.0 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (20, 1, 7.65, 2.91, 3.85, 38.24, 48.16, 20.7, 55.0, 'Moderate', '2026-06-28 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.65
DO: 2.91 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (21, 1, 7.44, 6.27, 10.49, 26.53, 58.13, 18.93, 60.0, 'Moderate', '2026-06-27 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.44
DO: 6.27 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (22, 1, 7.48, 5.22, 3.38, 12.08, 46.07, 25.51, 70.6, 'Moderate', '2026-06-26 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.48
DO: 5.22 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (23, 1, 7.52, 6.94, 10.61, 20.19, 41.36, 30.34, 65.6, 'Moderate', '2026-06-24 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.52
DO: 6.94 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (24, 1, 7.65, 3.85, 11.08, 34.3, 25.08, 31.22, 48.2, 'Poor', '2026-06-23 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.65
DO: 3.85 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (25, 1, 7.75, 2.73, 3.91, 17.04, 114.24, 20.76, 44.2, 'Poor', '2026-06-22 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.75
DO: 2.73 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (26, 1, 7.33, 6.49, 4.68, 11.64, 92.26, 30.49, 69.6, 'Moderate', '2026-06-22 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.33
DO: 6.49 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (27, 1, 7.01, 4.86, 1.68, 25.09, 53.21, 28.12, 73.5, 'Moderate', '2026-06-20 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.01
DO: 4.86 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (28, 1, 6.95, 5.86, 10.1, 19.28, 101.37, 19.71, 54.5, 'Moderate', '2026-06-20 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 6.95
DO: 5.86 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (29, 1, 8.2, 2.62, 8.35, 34.49, 17.59, 26.98, 45.1, 'Poor', '2026-06-18 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 8.2
DO: 2.62 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (30, 1, 7.09, 3.27, 9.44, 22.94, 17.74, 20.89, 52.1, 'Moderate', '2026-06-17 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Varanasi (Assi Ghat)
pH: 7.09
DO: 3.27 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (31, 2, 6.97, 8.7, 9.94, 33.89, 96.67, 20.61, 68.0, 'Moderate', '2026-07-17 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 6.97
DO: 8.7 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (32, 2, 7.57, 3.94, 3.6, 17.25, 30.38, 31.36, 64.4, 'Moderate', '2026-07-16 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.57
DO: 3.94 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (33, 2, 7.11, 6.83, 6.23, 9.64, 108.83, 19.46, 67.1, 'Moderate', '2026-07-14 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.11
DO: 6.83 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (34, 2, 7.01, 7.79, 5.04, 35.49, 76.54, 24.95, 80.2, 'Good', '2026-07-13 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.01
DO: 7.79 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (35, 2, 7.07, 5.89, 8.76, 11.62, 40.39, 18.25, 65.8, 'Moderate', '2026-07-13 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.07
DO: 5.89 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (36, 2, 8.37, 3.7, 1.52, 35.62, 54.49, 21.84, 60.1, 'Moderate', '2026-07-12 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 8.37
DO: 3.7 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (37, 2, 6.84, 5.12, 4.87, 11.13, 63.51, 27.58, 66.0, 'Moderate', '2026-07-11 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 6.84
DO: 5.12 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (38, 2, 6.91, 2.12, 7.36, 16.5, 102.56, 20.75, 38.2, 'Poor', '2026-07-09 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 6.91
DO: 2.12 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (39, 2, 7.53, 4.51, 11.8, 30.41, 79.88, 26.89, 43.5, 'Poor', '2026-07-08 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.53
DO: 4.51 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (40, 2, 7.58, 7.42, 7.77, 34.05, 61.76, 29.4, 71.4, 'Moderate', '2026-07-08 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.58
DO: 7.42 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (41, 2, 7.42, 9.48, 3.99, 34.56, 67.38, 27.88, 82.9, 'Good', '2026-07-07 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.42
DO: 9.48 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (42, 2, 8.37, 3.84, 9.63, 9.18, 35.15, 27.09, 46.2, 'Poor', '2026-07-05 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 8.37
DO: 3.84 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (43, 2, 8.33, 7.17, 3.56, 20.9, 30.5, 28.98, 79.5, 'Moderate', '2026-07-05 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 8.33
DO: 7.17 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (44, 2, 7.89, 5.7, 4.09, 19.74, 71.07, 18.63, 66.4, 'Moderate', '2026-07-03 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.89
DO: 5.7 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (45, 2, 6.85, 3.25, 9.65, 15.85, 114.36, 25.01, 37.9, 'Poor', '2026-07-02 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 6.85
DO: 3.25 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (46, 2, 7.92, 2.48, 3.85, 15.6, 27.15, 19.71, 54.0, 'Moderate', '2026-07-02 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.92
DO: 2.48 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (47, 2, 7.6, 6.65, 7.26, 5.98, 94.45, 25.25, 63.4, 'Moderate', '2026-06-30 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.6
DO: 6.65 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (48, 2, 7.49, 2.09, 11.06, 19.64, 17.02, 26.39, 39.9, 'Poor', '2026-06-30 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.49
DO: 2.09 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (49, 2, 7.34, 2.28, 6.87, 9.46, 33.07, 31.55, 48.5, 'Poor', '2026-06-29 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.34
DO: 2.28 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (50, 2, 7.44, 6.52, 5.87, 34.33, 71.4, 21.44, 69.6, 'Moderate', '2026-06-28 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.44
DO: 6.52 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (51, 2, 6.81, 3.62, 5.02, 35.27, 109.24, 27.04, 50.5, 'Moderate', '2026-06-26 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 6.81
DO: 3.62 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (52, 2, 7.89, 5.74, 2.7, 38.9, 52.95, 22.99, 72.1, 'Moderate', '2026-06-26 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.89
DO: 5.74 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (53, 2, 6.82, 3.23, 9.78, 22.14, 71.41, 25.09, 43.3, 'Poor', '2026-06-25 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 6.82
DO: 3.23 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (54, 2, 6.95, 7.2, 9.33, 39.0, 104.22, 25.04, 63.5, 'Moderate', '2026-06-24 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 6.95
DO: 7.2 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (55, 2, 7.41, 9.09, 2.91, 32.1, 82.06, 29.88, 83.2, 'Good', '2026-06-22 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.41
DO: 9.09 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (56, 2, 6.95, 3.62, 9.89, 32.95, 24.04, 31.47, 52.5, 'Moderate', '2026-06-21 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 6.95
DO: 3.62 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (57, 2, 8.2, 8.83, 10.93, 22.01, 34.83, 27.57, 68.6, 'Moderate', '2026-06-21 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 8.2
DO: 8.83 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (58, 2, 7.27, 6.95, 1.72, 16.2, 66.35, 28.9, 82.5, 'Good', '2026-06-20 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.27
DO: 6.95 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (59, 2, 7.1, 8.69, 6.74, 13.39, 70.4, 20.21, 78.2, 'Moderate', '2026-06-19 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 7.1
DO: 8.69 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (60, 2, 8.37, 2.83, 5.37, 35.68, 89.05, 19.61, 42.0, 'Poor', '2026-06-17 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kanpur (Jajmau)
pH: 8.37
DO: 2.83 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (61, 3, 8.26, 7.77, 8.72, 7.98, 114.45, 22.77, 60.7, 'Moderate', '2026-07-16 22:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.26
DO: 7.77 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (62, 3, 7.89, 8.93, 3.77, 33.1, 24.7, 25.74, 86.9, 'Good', '2026-07-16 03:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.89
DO: 8.93 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (63, 3, 7.59, 8.36, 4.54, 24.17, 71.88, 30.08, 80.2, 'Good', '2026-07-15 05:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.59
DO: 8.36 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (64, 3, 7.01, 2.0, 8.39, 14.74, 105.19, 23.27, 35.3, 'Poor', '2026-07-13 22:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.01
DO: 2.0 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (65, 3, 7.93, 2.26, 6.24, 13.16, 115.51, 30.86, 35.4, 'Poor', '2026-07-12 21:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.93
DO: 2.26 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (66, 3, 7.23, 3.99, 2.66, 27.25, 77.75, 22.96, 61.9, 'Moderate', '2026-07-12 05:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.23
DO: 3.99 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (67, 3, 7.27, 6.52, 5.84, 7.91, 28.93, 19.98, 76.3, 'Moderate', '2026-07-10 21:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.27
DO: 6.52 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (68, 3, 8.49, 8.86, 7.1, 33.68, 101.34, 26.66, 66.2, 'Moderate', '2026-07-10 01:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.49
DO: 8.86 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (69, 3, 8.43, 2.6, 6.37, 28.81, 89.71, 20.33, 38.2, 'Poor', '2026-07-08 20:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.43
DO: 2.6 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (70, 3, 7.14, 6.17, 5.33, 10.87, 78.68, 30.5, 69.2, 'Moderate', '2026-07-08 06:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.14
DO: 6.17 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (71, 3, 6.89, 4.01, 10.28, 30.29, 52.82, 21.58, 49.7, 'Poor', '2026-07-06 22:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 6.89
DO: 4.01 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (72, 3, 7.51, 8.66, 4.88, 33.14, 38.07, 21.77, 84.6, 'Good', '2026-07-06 00:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.51
DO: 8.66 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (73, 3, 8.22, 3.88, 8.95, 23.91, 90.23, 23.69, 41.1, 'Poor', '2026-07-05 06:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.22
DO: 3.88 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (74, 3, 7.03, 3.67, 4.09, 13.97, 118.81, 23.91, 52.3, 'Moderate', '2026-07-04 00:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.03
DO: 3.67 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (75, 3, 8.09, 8.58, 9.23, 9.55, 35.96, 20.39, 72.6, 'Moderate', '2026-07-03 01:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.09
DO: 8.58 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (76, 3, 7.59, 7.68, 5.41, 31.63, 110.97, 29.63, 71.1, 'Moderate', '2026-07-02 02:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.59
DO: 7.68 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (77, 3, 7.58, 9.28, 10.9, 8.66, 105.29, 26.08, 62.1, 'Moderate', '2026-06-30 21:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.58
DO: 9.28 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (78, 3, 7.15, 8.71, 10.16, 5.13, 71.91, 27.49, 70.4, 'Moderate', '2026-06-30 03:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.15
DO: 8.71 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (79, 3, 7.86, 6.04, 9.7, 5.58, 27.78, 20.34, 62.5, 'Moderate', '2026-06-28 22:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.86
DO: 6.04 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (80, 3, 6.96, 7.48, 7.82, 22.23, 17.36, 18.55, 80.4, 'Good', '2026-06-28 00:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 6.96
DO: 7.48 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (81, 3, 8.2, 3.41, 11.12, 19.84, 44.3, 27.07, 40.1, 'Poor', '2026-06-26 20:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.2
DO: 3.41 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (82, 3, 7.41, 8.49, 3.2, 12.18, 68.32, 29.85, 84.5, 'Good', '2026-06-25 21:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.41
DO: 8.49 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (83, 3, 7.69, 3.04, 5.97, 15.04, 92.2, 25.19, 44.9, 'Poor', '2026-06-25 00:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.69
DO: 3.04 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (84, 3, 8.17, 4.52, 6.13, 38.03, 90.04, 24.67, 51.1, 'Moderate', '2026-06-24 01:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.17
DO: 4.52 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (85, 3, 7.26, 3.41, 5.89, 13.54, 15.82, 28.41, 60.0, 'Moderate', '2026-06-23 05:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 7.26
DO: 3.41 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (86, 3, 8.29, 9.4, 1.76, 32.34, 70.24, 20.01, 82.9, 'Good', '2026-06-22 06:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.29
DO: 9.4 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (87, 3, 8.47, 7.59, 7.46, 27.94, 119.96, 26.71, 60.6, 'Moderate', '2026-06-21 01:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.47
DO: 7.59 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (88, 3, 6.84, 5.09, 2.03, 13.91, 19.38, 28.07, 78.0, 'Moderate', '2026-06-19 22:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 6.84
DO: 5.09 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (89, 3, 8.44, 3.49, 11.66, 17.5, 62.23, 28.81, 35.8, 'Poor', '2026-06-18 21:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 8.44
DO: 3.49 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (90, 3, 6.95, 6.22, 10.49, 25.93, 46.55, 21.84, 63.3, 'Moderate', '2026-06-17 21:27:19.657312', 'https://namamigange.gov.in/', 'Station: Haridwar (Har-Ki-Pauri)
pH: 6.95
DO: 6.22 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (91, 4, 8.34, 3.98, 4.13, 24.87, 47.32, 30.37, 57.3, 'Moderate', '2026-07-16 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 8.34
DO: 3.98 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (92, 4, 7.93, 8.15, 5.32, 13.0, 78.75, 18.49, 75.9, 'Moderate', '2026-07-16 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.93
DO: 8.15 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (93, 4, 7.18, 7.4, 5.4, 39.1, 28.35, 18.96, 83.0, 'Good', '2026-07-15 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.18
DO: 7.4 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (94, 4, 7.17, 2.27, 1.82, 10.04, 65.65, 27.13, 55.6, 'Moderate', '2026-07-14 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.17
DO: 2.27 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (95, 4, 7.52, 2.73, 2.54, 32.71, 23.2, 18.9, 60.8, 'Moderate', '2026-07-13 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.52
DO: 2.73 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (96, 4, 8.36, 3.23, 4.49, 24.87, 110.62, 25.49, 43.3, 'Poor', '2026-07-12 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 8.36
DO: 3.23 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (97, 4, 7.1, 5.04, 6.4, 25.02, 96.7, 31.41, 58.0, 'Moderate', '2026-07-11 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.1
DO: 5.04 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (98, 4, 7.01, 6.8, 6.96, 27.32, 67.42, 29.35, 71.6, 'Moderate', '2026-07-10 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.01
DO: 6.8 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (99, 4, 7.86, 9.22, 2.12, 30.79, 28.06, 27.69, 90.1, 'Good', '2026-07-09 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.86
DO: 9.22 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (100, 4, 6.97, 2.57, 4.62, 39.48, 28.97, 24.44, 57.1, 'Moderate', '2026-07-08 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 6.97
DO: 2.57 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (101, 4, 7.84, 9.32, 2.25, 7.09, 45.73, 24.29, 87.5, 'Good', '2026-07-06 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.84
DO: 9.32 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (102, 4, 7.7, 8.7, 6.17, 14.83, 88.31, 23.84, 73.9, 'Moderate', '2026-07-05 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.7
DO: 8.7 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (103, 4, 7.11, 8.27, 10.15, 28.33, 98.81, 23.07, 66.9, 'Moderate', '2026-07-04 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.11
DO: 8.27 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (104, 4, 7.62, 2.11, 11.27, 30.89, 105.45, 24.87, 26.7, 'Poor', '2026-07-04 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.62
DO: 2.11 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (105, 4, 7.98, 3.07, 4.51, 29.47, 93.64, 29.89, 46.6, 'Poor', '2026-07-02 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.98
DO: 3.07 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (106, 4, 7.38, 5.17, 9.54, 19.33, 67.5, 21.74, 54.7, 'Moderate', '2026-07-02 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.38
DO: 5.17 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (107, 4, 8.07, 9.46, 8.71, 22.68, 61.38, 31.61, 70.4, 'Moderate', '2026-07-01 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 8.07
DO: 9.46 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (108, 4, 7.62, 9.16, 2.32, 21.9, 86.82, 18.53, 82.8, 'Good', '2026-06-30 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.62
DO: 9.16 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (109, 4, 7.48, 8.2, 2.33, 38.84, 15.06, 31.3, 93.4, 'Good', '2026-06-29 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.48
DO: 8.2 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (110, 4, 6.82, 9.42, 4.85, 30.44, 63.14, 27.47, 82.8, 'Good', '2026-06-28 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 6.82
DO: 9.42 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (111, 4, 7.61, 3.62, 11.84, 19.96, 18.3, 24.78, 46.3, 'Poor', '2026-06-27 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.61
DO: 3.62 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (112, 4, 7.93, 2.86, 9.71, 10.13, 77.02, 22.26, 36.8, 'Poor', '2026-06-26 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.93
DO: 2.86 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (113, 4, 7.41, 3.0, 5.35, 5.26, 99.14, 22.48, 46.5, 'Poor', '2026-06-25 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.41
DO: 3.0 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (114, 4, 8.16, 6.7, 6.7, 33.47, 60.36, 26.84, 66.8, 'Moderate', '2026-06-24 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 8.16
DO: 6.7 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (115, 4, 8.22, 5.62, 10.28, 35.56, 99.04, 19.39, 47.2, 'Poor', '2026-06-22 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 8.22
DO: 5.62 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (116, 4, 7.0, 5.55, 10.53, 24.82, 98.3, 18.06, 52.4, 'Moderate', '2026-06-22 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.0
DO: 5.55 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (117, 4, 6.85, 7.55, 11.39, 8.22, 16.94, 26.82, 72.7, 'Moderate', '2026-06-20 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 6.85
DO: 7.55 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (118, 4, 6.89, 7.65, 3.24, 25.71, 27.05, 24.31, 89.6, 'Good', '2026-06-19 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 6.89
DO: 7.65 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (119, 4, 8.16, 4.64, 8.53, 13.36, 114.02, 22.61, 43.4, 'Poor', '2026-06-19 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 8.16
DO: 4.64 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (120, 4, 7.46, 5.44, 5.63, 8.96, 80.23, 21.38, 62.5, 'Moderate', '2026-06-17 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Patna (Digha Ghat)
pH: 7.46
DO: 5.44 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (121, 5, 6.81, 3.76, 7.86, 7.64, 81.26, 21.55, 49.1, 'Poor', '2026-07-16 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 6.81
DO: 3.76 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (122, 5, 6.97, 3.36, 6.85, 26.3, 68.92, 28.63, 51.4, 'Moderate', '2026-07-16 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 6.97
DO: 3.36 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (123, 5, 8.34, 9.35, 7.69, 18.56, 71.82, 28.5, 69.7, 'Moderate', '2026-07-14 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.34
DO: 9.35 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (124, 5, 8.44, 4.92, 11.68, 23.09, 60.58, 24.81, 44.3, 'Poor', '2026-07-14 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.44
DO: 4.92 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (125, 5, 7.99, 7.83, 6.87, 19.8, 86.05, 25.03, 70.3, 'Moderate', '2026-07-13 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.99
DO: 7.83 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (126, 5, 8.4, 7.54, 1.72, 24.81, 64.75, 29.74, 80.5, 'Good', '2026-07-12 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.4
DO: 7.54 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (127, 5, 7.31, 5.94, 4.65, 16.18, 58.7, 19.63, 71.2, 'Moderate', '2026-07-11 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.31
DO: 5.94 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (128, 5, 8.47, 6.96, 11.6, 21.89, 25.87, 20.89, 61.0, 'Moderate', '2026-07-09 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.47
DO: 6.96 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (129, 5, 7.2, 6.36, 8.05, 32.5, 18.35, 26.13, 72.5, 'Moderate', '2026-07-08 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.2
DO: 6.36 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (130, 5, 7.38, 5.1, 6.85, 24.96, 76.84, 30.47, 58.7, 'Moderate', '2026-07-07 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.38
DO: 5.1 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (131, 5, 7.76, 3.86, 3.27, 30.46, 59.21, 20.43, 59.7, 'Moderate', '2026-07-07 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.76
DO: 3.86 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (132, 5, 6.82, 4.4, 8.42, 29.5, 87.46, 30.35, 50.8, 'Moderate', '2026-07-06 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 6.82
DO: 4.4 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (133, 5, 7.79, 2.78, 10.77, 9.09, 60.0, 19.96, 37.1, 'Poor', '2026-07-04 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.79
DO: 2.78 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (134, 5, 7.23, 7.01, 4.53, 17.31, 79.64, 19.12, 75.2, 'Moderate', '2026-07-03 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.23
DO: 7.01 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (135, 5, 7.12, 3.57, 8.09, 36.77, 68.78, 18.61, 49.6, 'Poor', '2026-07-02 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.12
DO: 3.57 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (136, 5, 8.08, 3.67, 4.46, 34.72, 39.12, 29.97, 57.2, 'Moderate', '2026-07-02 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.08
DO: 3.67 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (137, 5, 8.3, 5.05, 2.16, 18.3, 45.25, 18.3, 68.3, 'Moderate', '2026-07-01 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.3
DO: 5.05 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (138, 5, 8.17, 2.36, 4.93, 34.63, 34.05, 30.42, 48.8, 'Poor', '2026-06-30 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.17
DO: 2.36 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (139, 5, 7.58, 2.77, 1.95, 27.15, 70.25, 23.04, 55.6, 'Moderate', '2026-06-29 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.58
DO: 2.77 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (140, 5, 8.03, 8.86, 4.52, 11.1, 94.76, 21.36, 74.9, 'Moderate', '2026-06-28 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.03
DO: 8.86 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (141, 5, 6.86, 9.26, 2.88, 31.36, 108.95, 25.59, 80.9, 'Good', '2026-06-27 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 6.86
DO: 9.26 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (142, 5, 7.94, 8.77, 5.04, 19.44, 97.67, 27.77, 73.9, 'Moderate', '2026-06-26 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.94
DO: 8.77 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (143, 5, 6.9, 5.52, 10.23, 15.82, 88.22, 20.77, 53.8, 'Moderate', '2026-06-25 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 6.9
DO: 5.52 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (144, 5, 8.44, 7.92, 3.79, 10.15, 67.38, 25.34, 77.8, 'Moderate', '2026-06-24 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.44
DO: 7.92 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (145, 5, 7.4, 7.22, 5.39, 23.74, 48.09, 29.8, 78.1, 'Moderate', '2026-06-22 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.4
DO: 7.22 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (146, 5, 8.06, 4.71, 6.52, 31.68, 30.37, 22.25, 60.2, 'Moderate', '2026-06-22 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 8.06
DO: 4.71 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (147, 5, 6.9, 9.46, 5.62, 20.3, 100.14, 26.48, 76.5, 'Moderate', '2026-06-21 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 6.9
DO: 9.46 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (148, 5, 6.95, 6.18, 3.74, 7.0, 93.16, 20.57, 71.1, 'Moderate', '2026-06-19 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 6.95
DO: 6.18 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (149, 5, 7.25, 8.35, 4.0, 18.08, 83.08, 26.14, 81.6, 'Good', '2026-06-19 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 7.25
DO: 8.35 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (150, 5, 6.92, 5.81, 2.27, 26.37, 15.66, 22.72, 82.6, 'Good', '2026-06-18 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Kolkata (Garden Reach)
pH: 6.92
DO: 5.81 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (151, 6, 7.56, 5.39, 4.95, 24.33, 77.83, 24.65, 63.5, 'Moderate', '2026-07-17 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.56
DO: 5.39 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (152, 6, 8.36, 2.24, 7.41, 17.52, 60.09, 26.6, 38.3, 'Poor', '2026-07-15 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 8.36
DO: 2.24 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (153, 6, 8.13, 7.15, 9.97, 35.42, 31.21, 25.52, 66.6, 'Moderate', '2026-07-15 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 8.13
DO: 7.15 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (154, 6, 7.58, 9.39, 7.59, 8.76, 116.97, 25.47, 67.5, 'Moderate', '2026-07-13 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.58
DO: 9.39 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (155, 6, 7.24, 7.84, 10.98, 5.99, 99.5, 26.03, 63.4, 'Moderate', '2026-07-13 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.24
DO: 7.84 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (156, 6, 8.24, 4.86, 7.07, 12.86, 105.39, 31.95, 48.6, 'Poor', '2026-07-12 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 8.24
DO: 4.86 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (157, 6, 7.43, 8.49, 3.7, 7.37, 96.85, 22.94, 79.4, 'Moderate', '2026-07-11 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.43
DO: 8.49 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (158, 6, 7.16, 3.71, 8.06, 8.71, 115.55, 21.04, 43.8, 'Poor', '2026-07-10 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.16
DO: 3.71 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (159, 6, 7.88, 2.08, 7.75, 39.81, 63.81, 30.45, 38.5, 'Poor', '2026-07-08 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.88
DO: 2.08 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (160, 6, 7.44, 3.09, 6.14, 32.58, 115.3, 20.23, 42.9, 'Poor', '2026-07-07 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.44
DO: 3.09 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (161, 6, 8.32, 3.96, 5.24, 26.87, 16.5, 22.87, 59.2, 'Moderate', '2026-07-06 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 8.32
DO: 3.96 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (162, 6, 7.19, 7.48, 9.72, 28.23, 71.31, 22.68, 68.2, 'Moderate', '2026-07-05 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.19
DO: 7.48 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (163, 6, 7.98, 8.71, 10.94, 6.54, 57.2, 29.62, 66.6, 'Moderate', '2026-07-05 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.98
DO: 8.71 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (164, 6, 8.03, 7.24, 2.87, 18.24, 83.53, 24.84, 75.6, 'Moderate', '2026-07-03 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 8.03
DO: 7.24 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (165, 6, 7.57, 4.69, 7.8, 11.82, 88.54, 23.69, 51.7, 'Moderate', '2026-07-03 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.57
DO: 4.69 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (166, 6, 6.98, 5.65, 9.62, 21.11, 95.57, 22.57, 55.2, 'Moderate', '2026-07-01 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 6.98
DO: 5.65 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (167, 6, 7.39, 2.44, 5.03, 26.13, 119.1, 28.28, 41.2, 'Poor', '2026-06-30 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.39
DO: 2.44 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (168, 6, 7.7, 5.5, 3.52, 26.71, 28.53, 24.03, 73.3, 'Moderate', '2026-06-30 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.7
DO: 5.5 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (169, 6, 6.88, 7.22, 7.01, 19.38, 106.12, 21.67, 68.0, 'Moderate', '2026-06-28 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 6.88
DO: 7.22 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (170, 6, 7.26, 3.1, 11.9, 39.15, 62.95, 31.96, 38.8, 'Poor', '2026-06-28 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.26
DO: 3.1 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (171, 6, 6.87, 8.46, 10.27, 5.34, 104.25, 18.16, 65.8, 'Moderate', '2026-06-27 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 6.87
DO: 8.46 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (172, 6, 7.75, 2.71, 8.63, 21.23, 100.78, 25.51, 35.8, 'Poor', '2026-06-26 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.75
DO: 2.71 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (173, 6, 8.45, 9.29, 4.22, 29.26, 13.61, 18.23, 84.7, 'Good', '2026-06-25 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 8.45
DO: 9.29 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (174, 6, 6.93, 2.03, 5.54, 35.14, 118.18, 21.91, 39.5, 'Poor', '2026-06-23 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 6.93
DO: 2.03 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (175, 6, 7.88, 6.58, 8.39, 23.78, 94.21, 19.87, 59.2, 'Moderate', '2026-06-22 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.88
DO: 6.58 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (176, 6, 7.05, 7.4, 8.56, 16.75, 17.02, 29.72, 78.4, 'Moderate', '2026-06-22 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.05
DO: 7.4 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (177, 6, 7.46, 8.83, 6.74, 16.9, 116.98, 20.8, 70.0, 'Moderate', '2026-06-20 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.46
DO: 8.83 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (178, 6, 8.32, 5.3, 8.18, 25.9, 65.76, 21.53, 53.9, 'Moderate', '2026-06-20 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 8.32
DO: 5.3 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (179, 6, 7.0, 8.23, 7.45, 31.63, 37.2, 24.32, 81.7, 'Good', '2026-06-19 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.0
DO: 8.23 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (180, 6, 7.87, 7.76, 3.99, 36.11, 11.26, 29.98, 87.0, 'Good', '2026-06-17 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Delhi (ITO Bridge)
pH: 7.87
DO: 7.76 mg/L
', '2026-07-17 07:27:19', '2026-07-17 07:27:19');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (181, 7, 7.09, 4.35, 6.64, 8.9, 50.66, 31.66, 59.9, 'Moderate', '2026-07-16 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.09
DO: 4.35 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (182, 7, 6.96, 5.27, 9.5, 32.06, 79.36, 25.89, 55.4, 'Moderate', '2026-07-16 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 6.96
DO: 5.27 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (183, 7, 7.97, 6.15, 5.19, 9.59, 12.44, 22.88, 74.4, 'Moderate', '2026-07-15 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.97
DO: 6.15 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (184, 7, 8.31, 2.97, 5.37, 37.87, 89.99, 26.76, 43.0, 'Poor', '2026-07-13 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 8.31
DO: 2.97 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (185, 7, 6.88, 8.88, 12.0, 34.57, 25.06, 24.12, 73.1, 'Moderate', '2026-07-12 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 6.88
DO: 8.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (186, 7, 7.53, 3.1, 5.48, 9.01, 95.25, 27.16, 46.7, 'Poor', '2026-07-12 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.53
DO: 3.1 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (187, 7, 7.89, 8.66, 1.65, 6.19, 88.95, 27.25, 82.6, 'Good', '2026-07-10 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.89
DO: 8.66 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (188, 7, 7.78, 7.28, 11.44, 32.85, 37.41, 26.29, 65.1, 'Moderate', '2026-07-10 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.78
DO: 7.28 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (189, 7, 7.9, 8.98, 1.65, 13.6, 82.35, 18.38, 83.4, 'Good', '2026-07-08 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.9
DO: 8.98 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (190, 7, 8.04, 5.71, 5.02, 26.77, 93.23, 20.13, 60.7, 'Moderate', '2026-07-08 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 8.04
DO: 5.71 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (191, 7, 7.79, 5.02, 1.71, 16.51, 27.3, 21.32, 74.1, 'Moderate', '2026-07-07 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.79
DO: 5.02 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (192, 7, 7.84, 5.58, 5.13, 37.88, 61.5, 31.89, 65.0, 'Moderate', '2026-07-05 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.84
DO: 5.58 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (193, 7, 8.46, 3.13, 2.85, 20.41, 106.0, 22.85, 46.4, 'Poor', '2026-07-04 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 8.46
DO: 3.13 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (194, 7, 7.09, 8.26, 6.1, 21.09, 39.87, 25.01, 83.8, 'Good', '2026-07-04 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.09
DO: 8.26 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (195, 7, 6.93, 9.41, 2.45, 23.58, 11.65, 20.62, 95.6, 'Good', '2026-07-02 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 6.93
DO: 9.41 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (196, 7, 7.08, 3.64, 4.96, 36.3, 71.71, 31.74, 56.5, 'Moderate', '2026-07-01 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.08
DO: 3.64 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (197, 7, 8.05, 2.25, 3.12, 35.64, 64.36, 29.59, 48.5, 'Poor', '2026-07-01 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 8.05
DO: 2.25 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (198, 7, 7.56, 2.23, 3.0, 17.69, 98.91, 18.09, 46.3, 'Poor', '2026-06-30 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.56
DO: 2.23 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (199, 7, 8.43, 6.29, 3.96, 28.98, 57.88, 18.63, 69.2, 'Moderate', '2026-06-29 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 8.43
DO: 6.29 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (200, 7, 7.31, 6.58, 10.12, 7.33, 80.62, 23.29, 60.2, 'Moderate', '2026-06-27 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.31
DO: 6.58 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (201, 7, 7.83, 3.37, 5.0, 30.36, 102.21, 23.19, 46.9, 'Poor', '2026-06-27 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.83
DO: 3.37 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (202, 7, 7.34, 3.92, 3.89, 33.27, 35.59, 31.05, 64.1, 'Moderate', '2026-06-25 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.34
DO: 3.92 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (203, 7, 7.77, 5.3, 11.2, 7.0, 27.93, 23.18, 55.4, 'Moderate', '2026-06-24 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.77
DO: 5.3 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (204, 7, 8.29, 7.03, 3.9, 16.33, 36.66, 21.33, 77.3, 'Moderate', '2026-06-23 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 8.29
DO: 7.03 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (205, 7, 7.82, 2.59, 11.14, 16.79, 119.59, 24.22, 26.8, 'Poor', '2026-06-23 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.82
DO: 2.59 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (206, 7, 7.36, 8.82, 5.88, 20.51, 63.43, 29.51, 79.7, 'Moderate', '2026-06-22 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.36
DO: 8.82 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (207, 7, 6.88, 2.37, 7.1, 37.1, 23.71, 23.63, 50.9, 'Moderate', '2026-06-21 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 6.88
DO: 2.37 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (208, 7, 8.27, 4.83, 2.0, 31.28, 87.82, 23.19, 61.6, 'Moderate', '2026-06-19 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 8.27
DO: 4.83 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (209, 7, 7.61, 4.23, 3.99, 29.67, 39.86, 31.35, 63.7, 'Moderate', '2026-06-19 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.61
DO: 4.23 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (210, 7, 7.69, 3.6, 11.45, 8.42, 80.05, 28.24, 38.1, 'Poor', '2026-06-17 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Mathura (Vishram Ghat)
pH: 7.69
DO: 3.6 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (211, 8, 8.06, 5.52, 7.23, 9.75, 87.97, 23.35, 55.4, 'Moderate', '2026-07-17 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.06
DO: 5.52 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (212, 8, 8.23, 4.09, 4.61, 28.38, 16.11, 26.04, 61.8, 'Moderate', '2026-07-16 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.23
DO: 4.09 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (213, 8, 8.23, 4.56, 7.18, 5.55, 96.76, 18.73, 47.9, 'Poor', '2026-07-15 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.23
DO: 4.56 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (214, 8, 7.91, 2.43, 9.18, 10.21, 56.48, 31.79, 38.3, 'Poor', '2026-07-14 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.91
DO: 2.43 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (215, 8, 7.58, 7.93, 8.19, 30.84, 20.2, 28.87, 79.2, 'Moderate', '2026-07-12 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.58
DO: 7.93 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (216, 8, 7.13, 4.24, 2.14, 35.23, 27.35, 30.35, 71.9, 'Moderate', '2026-07-12 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.13
DO: 4.24 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (217, 8, 7.6, 5.19, 5.51, 37.77, 72.9, 30.05, 61.6, 'Moderate', '2026-07-11 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.6
DO: 5.19 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (218, 8, 8.25, 9.28, 8.04, 15.36, 110.57, 18.49, 64.1, 'Moderate', '2026-07-10 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.25
DO: 9.28 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (219, 8, 7.69, 6.69, 8.93, 10.1, 106.64, 21.79, 57.9, 'Moderate', '2026-07-09 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.69
DO: 6.69 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (220, 8, 7.86, 9.1, 7.71, 15.3, 41.34, 23.49, 76.3, 'Moderate', '2026-07-08 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.86
DO: 9.1 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (221, 8, 6.9, 2.72, 3.25, 17.23, 109.24, 18.98, 49.5, 'Poor', '2026-07-07 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 6.9
DO: 2.72 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (222, 8, 7.66, 6.05, 4.98, 23.87, 55.71, 20.58, 69.8, 'Moderate', '2026-07-06 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.66
DO: 6.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (223, 8, 8.44, 6.27, 6.27, 6.25, 51.13, 20.98, 65.1, 'Moderate', '2026-07-04 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.44
DO: 6.27 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (224, 8, 7.97, 8.0, 11.22, 21.98, 54.64, 31.42, 66.4, 'Moderate', '2026-07-04 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.97
DO: 8.0 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (225, 8, 7.18, 4.65, 9.74, 35.92, 110.15, 25.85, 46.3, 'Poor', '2026-07-02 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.18
DO: 4.65 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (226, 8, 7.36, 6.74, 8.06, 27.49, 33.21, 21.18, 71.8, 'Moderate', '2026-07-01 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.36
DO: 6.74 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (227, 8, 7.34, 2.36, 2.3, 8.23, 28.77, 18.78, 59.3, 'Moderate', '2026-06-30 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.34
DO: 2.36 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (228, 8, 7.98, 5.08, 2.16, 17.69, 105.45, 26.23, 61.7, 'Moderate', '2026-06-29 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.98
DO: 5.08 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (229, 8, 7.27, 9.25, 8.18, 15.86, 56.38, 27.68, 76.2, 'Moderate', '2026-06-29 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.27
DO: 9.25 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (230, 8, 7.59, 5.65, 6.73, 32.17, 68.74, 19.7, 62.3, 'Moderate', '2026-06-28 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.59
DO: 5.65 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (231, 8, 8.18, 8.27, 5.77, 5.41, 14.09, 29.67, 82.6, 'Good', '2026-06-27 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.18
DO: 8.27 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (232, 8, 8.36, 6.94, 5.19, 23.1, 95.32, 19.01, 65.6, 'Moderate', '2026-06-26 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.36
DO: 6.94 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (233, 8, 6.95, 7.53, 11.65, 34.36, 52.03, 30.16, 67.7, 'Moderate', '2026-06-25 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 6.95
DO: 7.53 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (234, 8, 8.38, 4.48, 2.93, 32.51, 46.22, 25.45, 62.7, 'Moderate', '2026-06-24 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.38
DO: 4.48 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (235, 8, 8.19, 3.51, 4.22, 20.63, 94.68, 31.09, 48.6, 'Poor', '2026-06-22 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.19
DO: 3.51 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (236, 8, 7.06, 4.53, 7.23, 14.99, 24.28, 31.71, 63.4, 'Moderate', '2026-06-21 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.06
DO: 4.53 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (237, 8, 6.93, 3.91, 3.49, 30.55, 47.91, 18.07, 64.5, 'Moderate', '2026-06-21 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 6.93
DO: 3.91 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (238, 8, 8.21, 2.48, 11.07, 14.94, 52.36, 27.88, 33.6, 'Poor', '2026-06-19 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 8.21
DO: 2.48 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (239, 8, 7.44, 8.18, 3.98, 22.75, 68.25, 25.53, 82.7, 'Good', '2026-06-19 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 7.44
DO: 8.18 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (240, 8, 6.8, 5.33, 9.24, 20.42, 25.7, 18.02, 62.9, 'Moderate', '2026-06-18 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Agra (Taj Ghat)
pH: 6.8
DO: 5.33 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (241, 9, 7.69, 5.75, 7.73, 33.16, 95.55, 24.77, 56.5, 'Moderate', '2026-07-17 02:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.69
DO: 5.75 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (242, 9, 6.87, 3.13, 7.79, 27.05, 52.74, 29.9, 49.8, 'Poor', '2026-07-15 21:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 6.87
DO: 3.13 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (243, 9, 8.21, 3.17, 3.36, 37.91, 77.49, 26.88, 50.7, 'Moderate', '2026-07-15 01:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 8.21
DO: 3.17 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (244, 9, 8.22, 6.59, 10.13, 12.12, 63.79, 20.53, 58.0, 'Moderate', '2026-07-13 19:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 8.22
DO: 6.59 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (245, 9, 8.28, 5.98, 1.93, 27.88, 55.91, 26.52, 72.8, 'Moderate', '2026-07-12 19:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 8.28
DO: 5.98 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (246, 9, 7.27, 7.98, 9.55, 16.14, 56.98, 28.07, 73.0, 'Moderate', '2026-07-12 04:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.27
DO: 7.98 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (247, 9, 7.89, 2.78, 10.15, 6.16, 47.91, 27.55, 39.6, 'Poor', '2026-07-10 21:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.89
DO: 2.78 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (248, 9, 7.8, 7.77, 11.55, 28.9, 115.88, 21.54, 56.8, 'Moderate', '2026-07-09 19:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.8
DO: 7.77 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (249, 9, 6.84, 5.09, 10.27, 23.47, 48.59, 24.17, 56.3, 'Moderate', '2026-07-08 20:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 6.84
DO: 5.09 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (250, 9, 7.6, 2.29, 9.96, 28.7, 42.7, 31.5, 39.3, 'Poor', '2026-07-07 23:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.6
DO: 2.29 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (251, 9, 6.96, 3.15, 9.07, 35.19, 79.88, 24.68, 43.9, 'Poor', '2026-07-07 00:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 6.96
DO: 3.15 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (252, 9, 7.09, 8.75, 8.78, 18.48, 16.3, 30.21, 81.3, 'Good', '2026-07-05 22:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.09
DO: 8.75 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (253, 9, 6.96, 5.62, 3.12, 6.76, 64.66, 27.0, 73.1, 'Moderate', '2026-07-05 06:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 6.96
DO: 5.62 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (254, 9, 6.82, 8.78, 10.64, 23.14, 25.96, 20.74, 75.6, 'Moderate', '2026-07-04 03:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 6.82
DO: 8.78 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (255, 9, 7.13, 2.21, 8.5, 27.27, 20.08, 30.91, 47.4, 'Poor', '2026-07-03 00:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.13
DO: 2.21 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (256, 9, 7.24, 5.02, 2.17, 10.37, 74.82, 27.85, 69.3, 'Moderate', '2026-07-02 04:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.24
DO: 5.02 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (257, 9, 8.48, 9.31, 4.74, 39.26, 48.03, 23.19, 78.7, 'Moderate', '2026-07-01 06:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 8.48
DO: 9.31 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (258, 9, 7.36, 8.93, 9.74, 36.29, 104.77, 30.12, 65.7, 'Moderate', '2026-06-30 01:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.36
DO: 8.93 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (259, 9, 8.1, 8.09, 10.34, 38.51, 47.98, 29.34, 68.6, 'Moderate', '2026-06-28 21:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 8.1
DO: 8.09 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (260, 9, 6.96, 5.75, 9.16, 19.14, 26.33, 18.53, 66.2, 'Moderate', '2026-06-28 07:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 6.96
DO: 5.75 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (261, 9, 8.34, 3.22, 4.47, 39.45, 57.32, 30.29, 50.8, 'Moderate', '2026-06-27 01:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 8.34
DO: 3.22 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (262, 9, 7.23, 8.86, 5.17, 39.25, 21.26, 26.72, 87.7, 'Good', '2026-06-26 07:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.23
DO: 8.86 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (263, 9, 7.8, 6.85, 5.08, 34.45, 47.95, 18.59, 74.6, 'Moderate', '2026-06-25 03:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.8
DO: 6.85 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (264, 9, 7.44, 8.67, 8.0, 20.19, 65.5, 31.33, 74.5, 'Moderate', '2026-06-24 04:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.44
DO: 8.67 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (265, 9, 7.02, 6.86, 8.65, 16.27, 35.82, 23.86, 72.6, 'Moderate', '2026-06-22 22:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.02
DO: 6.86 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (266, 9, 7.08, 2.93, 6.2, 17.39, 87.97, 27.93, 47.4, 'Poor', '2026-06-22 00:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.08
DO: 2.93 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (267, 9, 8.18, 5.89, 6.3, 26.27, 117.82, 20.79, 54.9, 'Moderate', '2026-06-21 01:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 8.18
DO: 5.89 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (268, 9, 7.85, 9.28, 11.08, 10.38, 78.11, 23.97, 64.1, 'Moderate', '2026-06-19 23:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.85
DO: 9.28 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (269, 9, 7.48, 8.62, 9.79, 12.62, 59.05, 22.31, 71.3, 'Moderate', '2026-06-19 07:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.48
DO: 8.62 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (270, 9, 7.08, 8.43, 11.31, 36.3, 117.86, 20.6, 61.9, 'Moderate', '2026-06-18 06:27:19.657312', 'https://namamigange.gov.in/', 'Station: Prayagraj (Sangam)
pH: 7.08
DO: 8.43 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (271, 10, 7.36, 3.7, 5.49, 15.69, 60.28, 22.88, 55.9, 'Moderate', '2026-07-17 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.36
DO: 3.7 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (272, 10, 7.27, 8.53, 6.76, 28.91, 23.09, 28.55, 83.8, 'Good', '2026-07-16 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.27
DO: 8.53 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (273, 10, 6.81, 3.49, 4.42, 20.2, 50.85, 29.04, 59.1, 'Moderate', '2026-07-15 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 6.81
DO: 3.49 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (274, 10, 7.15, 5.05, 5.23, 16.93, 79.39, 21.52, 62.7, 'Moderate', '2026-07-13 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.15
DO: 5.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (275, 10, 8.08, 5.04, 4.06, 11.34, 22.08, 27.35, 68.4, 'Moderate', '2026-07-12 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 8.08
DO: 5.04 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (276, 10, 7.65, 7.99, 7.0, 17.06, 94.95, 28.31, 71.4, 'Moderate', '2026-07-12 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.65
DO: 7.99 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (277, 10, 7.11, 6.71, 3.59, 9.41, 96.09, 27.51, 73.8, 'Moderate', '2026-07-10 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.11
DO: 6.71 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (278, 10, 8.03, 7.16, 6.04, 26.07, 58.56, 26.44, 71.8, 'Moderate', '2026-07-09 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 8.03
DO: 7.16 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (279, 10, 7.2, 3.14, 2.58, 6.35, 16.39, 21.02, 65.7, 'Moderate', '2026-07-08 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.2
DO: 3.14 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (280, 10, 8.01, 3.68, 5.43, 10.01, 34.44, 25.59, 56.2, 'Moderate', '2026-07-07 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 8.01
DO: 3.68 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (281, 10, 6.93, 6.46, 10.55, 15.09, 38.99, 22.21, 65.5, 'Moderate', '2026-07-07 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 6.93
DO: 6.46 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (282, 10, 8.45, 5.57, 1.54, 25.68, 62.88, 21.91, 69.4, 'Moderate', '2026-07-05 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 8.45
DO: 5.57 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (283, 10, 7.54, 8.15, 3.94, 24.1, 62.27, 22.61, 83.1, 'Good', '2026-07-04 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.54
DO: 8.15 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (284, 10, 7.9, 5.2, 2.54, 11.79, 48.05, 28.76, 69.9, 'Moderate', '2026-07-04 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.9
DO: 5.2 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (285, 10, 7.46, 7.38, 3.92, 22.83, 105.5, 21.92, 74.0, 'Moderate', '2026-07-03 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.46
DO: 7.38 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (286, 10, 8.2, 9.01, 2.54, 30.0, 71.87, 27.4, 81.5, 'Good', '2026-07-02 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 8.2
DO: 9.01 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (287, 10, 7.91, 5.23, 2.91, 22.11, 113.14, 20.22, 60.3, 'Moderate', '2026-07-01 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.91
DO: 5.23 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (288, 10, 7.18, 5.78, 3.78, 8.78, 47.1, 23.78, 74.4, 'Moderate', '2026-06-29 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.18
DO: 5.78 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (289, 10, 7.46, 4.32, 11.13, 39.11, 22.31, 19.75, 52.1, 'Moderate', '2026-06-28 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.46
DO: 4.32 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (290, 10, 8.21, 3.05, 9.58, 18.92, 21.14, 28.62, 44.5, 'Poor', '2026-06-28 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 8.21
DO: 3.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (291, 10, 7.5, 3.45, 5.78, 20.36, 97.46, 27.1, 48.0, 'Poor', '2026-06-27 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.5
DO: 3.45 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (292, 10, 7.2, 7.5, 9.0, 13.69, 114.81, 19.7, 63.8, 'Moderate', '2026-06-26 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.2
DO: 7.5 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (293, 10, 7.13, 4.5, 8.34, 31.85, 86.7, 19.29, 51.9, 'Moderate', '2026-06-24 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.13
DO: 4.5 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (294, 10, 7.08, 4.35, 7.14, 12.95, 69.17, 27.74, 56.3, 'Moderate', '2026-06-23 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.08
DO: 4.35 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (295, 10, 8.23, 5.34, 2.6, 13.12, 44.65, 19.31, 69.4, 'Moderate', '2026-06-22 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 8.23
DO: 5.34 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (296, 10, 7.17, 6.9, 4.3, 25.52, 34.29, 21.9, 81.6, 'Good', '2026-06-22 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.17
DO: 6.9 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (297, 10, 8.48, 4.83, 11.8, 17.19, 70.5, 22.66, 41.9, 'Poor', '2026-06-20 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 8.48
DO: 4.83 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (298, 10, 8.18, 5.4, 9.88, 17.69, 48.78, 22.96, 53.9, 'Moderate', '2026-06-19 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 8.18
DO: 5.4 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (299, 10, 7.54, 5.51, 10.72, 21.08, 60.2, 27.8, 54.3, 'Moderate', '2026-06-19 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.54
DO: 5.51 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (300, 10, 7.89, 4.9, 5.93, 15.39, 25.4, 22.64, 64.1, 'Moderate', '2026-06-18 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Nashik (Ramkund)
pH: 7.89
DO: 4.9 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (301, 11, 8.2, 5.95, 10.64, 20.67, 45.5, 29.28, 55.8, 'Moderate', '2026-07-16 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.2
DO: 5.95 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (302, 11, 7.84, 3.66, 7.72, 20.76, 101.38, 19.3, 42.8, 'Poor', '2026-07-16 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.84
DO: 3.66 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (303, 11, 6.95, 5.03, 1.9, 37.84, 41.09, 31.2, 75.5, 'Moderate', '2026-07-14 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 6.95
DO: 5.03 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (304, 11, 7.48, 3.83, 1.65, 19.52, 57.38, 27.68, 64.7, 'Moderate', '2026-07-14 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.48
DO: 3.83 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (305, 11, 8.06, 6.78, 3.92, 12.25, 21.83, 23.54, 79.0, 'Moderate', '2026-07-12 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.06
DO: 6.78 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (306, 11, 6.93, 3.55, 2.72, 9.53, 38.1, 24.63, 65.4, 'Moderate', '2026-07-12 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 6.93
DO: 3.55 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (307, 11, 8.11, 5.42, 9.98, 39.76, 59.99, 22.99, 52.6, 'Moderate', '2026-07-11 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.11
DO: 5.42 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (308, 11, 8.37, 5.48, 9.56, 27.71, 106.01, 26.94, 46.2, 'Poor', '2026-07-09 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.37
DO: 5.48 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (309, 11, 7.29, 9.32, 5.66, 22.87, 79.8, 23.46, 78.2, 'Moderate', '2026-07-09 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.29
DO: 9.32 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (310, 11, 7.0, 9.01, 12.0, 25.43, 29.48, 30.16, 73.1, 'Moderate', '2026-07-07 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.0
DO: 9.01 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (311, 11, 7.72, 2.3, 6.51, 29.76, 98.34, 23.99, 38.5, 'Poor', '2026-07-06 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.72
DO: 2.3 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (312, 11, 8.21, 7.05, 4.3, 23.48, 88.67, 23.52, 69.8, 'Moderate', '2026-07-05 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.21
DO: 7.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (313, 11, 7.53, 5.07, 5.44, 7.21, 102.85, 30.6, 57.2, 'Moderate', '2026-07-04 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.53
DO: 5.07 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (314, 11, 7.71, 8.05, 1.98, 10.5, 74.46, 25.32, 84.8, 'Good', '2026-07-04 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.71
DO: 8.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (315, 11, 7.17, 2.7, 7.35, 11.84, 54.33, 24.45, 47.8, 'Poor', '2026-07-03 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.17
DO: 2.7 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (316, 11, 7.71, 7.81, 8.81, 39.16, 68.89, 30.21, 69.8, 'Moderate', '2026-07-02 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.71
DO: 7.81 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (317, 11, 7.93, 8.56, 9.49, 9.16, 97.01, 19.83, 64.5, 'Moderate', '2026-07-01 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.93
DO: 8.56 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (318, 11, 7.2, 3.04, 3.92, 33.56, 30.95, 30.86, 60.2, 'Moderate', '2026-06-30 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.2
DO: 3.04 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (319, 11, 7.86, 6.65, 6.03, 31.46, 88.06, 30.96, 65.6, 'Moderate', '2026-06-28 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.86
DO: 6.65 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (320, 11, 7.46, 8.01, 1.92, 23.42, 35.94, 23.0, 91.5, 'Good', '2026-06-28 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.46
DO: 8.01 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (321, 11, 8.21, 6.29, 9.74, 31.0, 45.36, 28.16, 59.7, 'Moderate', '2026-06-26 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.21
DO: 6.29 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (322, 11, 8.04, 9.03, 8.69, 11.14, 42.08, 26.13, 73.2, 'Moderate', '2026-06-26 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.04
DO: 9.03 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (323, 11, 6.81, 3.23, 8.79, 25.31, 12.78, 20.18, 53.5, 'Moderate', '2026-06-25 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 6.81
DO: 3.23 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (324, 11, 6.8, 3.38, 3.57, 5.83, 18.69, 27.44, 64.7, 'Moderate', '2026-06-23 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 6.8
DO: 3.38 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (325, 11, 8.07, 6.74, 2.01, 7.44, 57.58, 21.34, 77.9, 'Moderate', '2026-06-23 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.07
DO: 6.74 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (326, 11, 8.04, 8.24, 10.38, 19.03, 66.51, 22.49, 66.2, 'Moderate', '2026-06-21 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.04
DO: 8.24 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (327, 11, 7.28, 9.22, 11.17, 38.29, 58.11, 19.54, 69.5, 'Moderate', '2026-06-20 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.28
DO: 9.22 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (328, 11, 7.41, 6.46, 1.65, 37.73, 102.39, 31.35, 74.1, 'Moderate', '2026-06-20 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.41
DO: 6.46 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (329, 11, 8.41, 4.88, 1.85, 32.71, 12.95, 29.23, 71.8, 'Moderate', '2026-06-19 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 8.41
DO: 4.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (330, 11, 7.61, 7.51, 6.09, 19.56, 116.78, 20.91, 67.8, 'Moderate', '2026-06-18 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Nanded
pH: 7.61
DO: 7.51 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (331, 12, 8.43, 2.99, 3.65, 13.4, 20.52, 30.98, 55.8, 'Moderate', '2026-07-17 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.43
DO: 2.99 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (332, 12, 6.81, 2.98, 9.15, 33.84, 107.84, 25.55, 38.1, 'Poor', '2026-07-16 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 6.81
DO: 2.98 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (333, 12, 8.03, 2.45, 11.66, 23.89, 56.57, 30.44, 32.5, 'Poor', '2026-07-15 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.03
DO: 2.45 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (334, 12, 7.63, 9.42, 5.31, 31.92, 35.19, 19.02, 83.5, 'Good', '2026-07-13 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.63
DO: 9.42 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (335, 12, 7.91, 9.18, 6.15, 35.86, 23.71, 23.19, 81.8, 'Good', '2026-07-13 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.91
DO: 9.18 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (336, 12, 8.25, 4.12, 6.06, 14.36, 23.53, 31.37, 57.7, 'Moderate', '2026-07-12 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.25
DO: 4.12 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (337, 12, 8.47, 8.75, 10.22, 5.04, 41.86, 19.59, 67.8, 'Moderate', '2026-07-11 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.47
DO: 8.75 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (338, 12, 8.41, 2.66, 6.05, 29.47, 81.52, 30.28, 40.4, 'Poor', '2026-07-10 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.41
DO: 2.66 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (339, 12, 8.24, 3.03, 5.87, 12.17, 78.43, 22.7, 44.2, 'Poor', '2026-07-09 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.24
DO: 3.03 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (340, 12, 6.87, 5.22, 11.86, 18.74, 25.9, 24.33, 57.0, 'Moderate', '2026-07-08 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 6.87
DO: 5.22 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (341, 12, 8.13, 3.88, 6.45, 6.82, 109.16, 19.49, 44.3, 'Poor', '2026-07-06 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.13
DO: 3.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (342, 12, 7.14, 5.35, 11.38, 11.71, 73.86, 18.57, 52.1, 'Moderate', '2026-07-05 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.14
DO: 5.35 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (343, 12, 7.27, 2.96, 2.88, 14.09, 114.21, 30.18, 50.2, 'Moderate', '2026-07-05 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.27
DO: 2.96 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (344, 12, 6.87, 6.14, 4.05, 15.03, 23.99, 25.74, 79.3, 'Moderate', '2026-07-03 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 6.87
DO: 6.14 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (345, 12, 8.29, 6.88, 9.22, 35.35, 28.85, 28.37, 66.1, 'Moderate', '2026-07-02 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.29
DO: 6.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (346, 12, 7.25, 6.05, 4.73, 32.5, 57.08, 29.42, 72.2, 'Moderate', '2026-07-02 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.25
DO: 6.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (347, 12, 7.43, 2.75, 5.89, 24.61, 52.89, 25.59, 50.1, 'Moderate', '2026-06-30 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.43
DO: 2.75 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (348, 12, 8.02, 6.37, 4.83, 11.93, 66.03, 27.87, 68.8, 'Moderate', '2026-06-30 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.02
DO: 6.37 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (349, 12, 7.14, 7.39, 11.82, 33.3, 105.81, 30.21, 58.7, 'Moderate', '2026-06-28 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.14
DO: 7.39 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (350, 12, 7.68, 3.41, 8.14, 19.32, 79.66, 29.54, 44.2, 'Poor', '2026-06-27 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.68
DO: 3.41 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (351, 12, 7.06, 4.46, 8.84, 16.96, 114.68, 27.58, 47.1, 'Poor', '2026-06-26 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.06
DO: 4.46 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (352, 12, 7.1, 5.45, 5.8, 6.35, 58.01, 25.12, 67.0, 'Moderate', '2026-06-26 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.1
DO: 5.45 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (353, 12, 7.38, 7.39, 9.96, 16.19, 40.09, 23.23, 70.5, 'Moderate', '2026-06-25 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.38
DO: 7.39 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (354, 12, 7.25, 6.49, 6.67, 18.56, 36.55, 20.03, 73.4, 'Moderate', '2026-06-23 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.25
DO: 6.49 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (355, 12, 7.53, 7.37, 1.77, 26.96, 48.66, 22.0, 86.0, 'Good', '2026-06-23 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.53
DO: 7.37 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (356, 12, 8.24, 2.12, 9.41, 15.8, 37.6, 22.43, 37.0, 'Poor', '2026-06-22 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.24
DO: 2.12 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (357, 12, 8.39, 4.64, 5.84, 38.1, 62.03, 24.79, 55.2, 'Moderate', '2026-06-20 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 8.39
DO: 4.64 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (358, 12, 7.26, 4.49, 4.07, 27.5, 59.23, 22.69, 64.2, 'Moderate', '2026-06-19 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.26
DO: 4.49 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (359, 12, 7.94, 5.33, 5.63, 27.32, 105.58, 28.79, 55.9, 'Moderate', '2026-06-19 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.94
DO: 5.33 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (360, 12, 7.98, 7.54, 6.23, 16.32, 109.0, 25.28, 66.9, 'Moderate', '2026-06-18 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Rajahmundry
pH: 7.98
DO: 7.54 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (361, 13, 8.01, 4.75, 2.15, 22.35, 34.43, 31.54, 69.5, 'Moderate', '2026-07-16 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.01
DO: 4.75 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (362, 13, 8.32, 3.51, 7.49, 9.6, 103.13, 25.15, 39.8, 'Poor', '2026-07-16 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.32
DO: 3.51 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (363, 13, 7.15, 4.45, 9.72, 10.42, 24.79, 31.08, 57.1, 'Moderate', '2026-07-14 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.15
DO: 4.45 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (364, 13, 7.22, 4.21, 6.66, 35.77, 54.98, 18.88, 57.8, 'Moderate', '2026-07-13 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.22
DO: 4.21 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (365, 13, 6.91, 3.14, 2.18, 37.13, 109.57, 19.46, 54.2, 'Moderate', '2026-07-13 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 6.91
DO: 3.14 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (366, 13, 6.91, 3.08, 10.93, 7.77, 14.15, 18.94, 48.3, 'Poor', '2026-07-12 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 6.91
DO: 3.08 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (367, 13, 8.39, 5.86, 6.5, 27.25, 31.78, 24.13, 65.1, 'Moderate', '2026-07-10 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.39
DO: 5.86 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (368, 13, 7.83, 7.19, 3.67, 19.26, 51.96, 18.75, 78.9, 'Moderate', '2026-07-10 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.83
DO: 7.19 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (369, 13, 7.79, 7.81, 11.95, 16.9, 48.53, 28.49, 65.5, 'Moderate', '2026-07-09 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.79
DO: 7.81 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (370, 13, 8.21, 5.64, 2.96, 35.55, 74.72, 20.18, 66.4, 'Moderate', '2026-07-08 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.21
DO: 5.64 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (371, 13, 6.82, 3.35, 1.92, 31.93, 64.05, 28.24, 61.9, 'Moderate', '2026-07-07 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 6.82
DO: 3.35 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (372, 13, 8.34, 9.31, 11.59, 26.71, 27.07, 29.2, 67.6, 'Moderate', '2026-07-05 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.34
DO: 9.31 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (373, 13, 7.37, 5.62, 4.32, 20.39, 97.93, 18.93, 64.3, 'Moderate', '2026-07-05 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.37
DO: 5.62 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (374, 13, 7.93, 5.96, 3.49, 11.27, 69.3, 20.8, 69.2, 'Moderate', '2026-07-03 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.93
DO: 5.96 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (375, 13, 6.9, 8.91, 4.28, 13.72, 88.0, 25.54, 81.0, 'Good', '2026-07-02 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 6.9
DO: 8.91 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (376, 13, 7.8, 6.63, 6.97, 14.54, 109.2, 22.6, 60.8, 'Moderate', '2026-07-02 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.8
DO: 6.63 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (377, 13, 7.86, 5.85, 10.4, 8.86, 57.49, 22.81, 55.8, 'Moderate', '2026-07-01 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.86
DO: 5.85 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (378, 13, 8.17, 9.09, 1.89, 17.17, 106.38, 19.98, 78.3, 'Moderate', '2026-06-29 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.17
DO: 9.09 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (379, 13, 7.25, 6.92, 11.78, 9.59, 71.73, 24.26, 60.1, 'Moderate', '2026-06-29 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.25
DO: 6.92 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (380, 13, 7.55, 8.91, 11.87, 38.11, 41.0, 30.27, 69.0, 'Moderate', '2026-06-28 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.55
DO: 8.91 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (381, 13, 7.31, 9.3, 11.36, 30.41, 62.75, 28.04, 68.3, 'Moderate', '2026-06-27 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.31
DO: 9.3 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (382, 13, 7.8, 7.28, 9.03, 24.29, 60.63, 28.09, 66.9, 'Moderate', '2026-06-26 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.8
DO: 7.28 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (383, 13, 8.01, 3.41, 10.95, 17.29, 42.79, 23.71, 41.6, 'Poor', '2026-06-25 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.01
DO: 3.41 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (384, 13, 8.37, 6.84, 6.52, 19.25, 37.85, 19.5, 70.0, 'Moderate', '2026-06-23 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.37
DO: 6.84 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (385, 13, 8.16, 7.2, 3.07, 37.88, 104.67, 22.98, 71.4, 'Moderate', '2026-06-23 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.16
DO: 7.2 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (386, 13, 7.97, 5.36, 10.39, 12.86, 18.91, 24.29, 57.7, 'Moderate', '2026-06-22 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.97
DO: 5.36 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (387, 13, 7.27, 3.71, 4.29, 39.2, 40.8, 24.1, 61.6, 'Moderate', '2026-06-20 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.27
DO: 3.71 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (388, 13, 6.85, 2.11, 4.0, 23.76, 27.16, 27.17, 55.4, 'Moderate', '2026-06-20 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 6.85
DO: 2.11 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (389, 13, 7.07, 2.13, 11.39, 6.86, 110.31, 27.33, 28.6, 'Poor', '2026-06-19 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 7.07
DO: 2.13 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (390, 13, 8.31, 8.71, 11.39, 37.08, 98.16, 22.13, 58.3, 'Moderate', '2026-06-18 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Sangli
pH: 8.31
DO: 8.71 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (391, 14, 7.41, 7.12, 3.26, 14.45, 56.52, 30.59, 80.9, 'Good', '2026-07-17 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.41
DO: 7.12 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (392, 14, 7.87, 5.79, 2.17, 26.97, 61.38, 27.8, 72.5, 'Moderate', '2026-07-16 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.87
DO: 5.79 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (393, 14, 8.44, 8.33, 10.28, 37.0, 30.33, 26.07, 69.4, 'Moderate', '2026-07-15 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 8.44
DO: 8.33 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (394, 14, 7.96, 4.47, 7.84, 23.12, 107.51, 29.44, 45.8, 'Poor', '2026-07-13 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.96
DO: 4.47 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (395, 14, 7.52, 7.9, 1.85, 10.54, 18.98, 19.03, 93.1, 'Good', '2026-07-12 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.52
DO: 7.9 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (396, 14, 7.39, 9.18, 8.03, 13.74, 40.88, 25.36, 78.0, 'Moderate', '2026-07-12 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.39
DO: 9.18 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (397, 14, 7.01, 3.06, 11.48, 19.84, 80.58, 29.22, 38.3, 'Poor', '2026-07-10 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.01
DO: 3.06 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (398, 14, 7.19, 2.77, 7.16, 16.86, 74.44, 20.74, 45.8, 'Poor', '2026-07-09 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.19
DO: 2.77 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (399, 14, 7.49, 7.98, 11.85, 32.28, 69.44, 23.32, 65.3, 'Moderate', '2026-07-09 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.49
DO: 7.98 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (400, 14, 8.35, 8.66, 5.15, 16.61, 65.59, 30.88, 76.0, 'Moderate', '2026-07-08 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 8.35
DO: 8.66 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (401, 14, 7.02, 5.09, 6.95, 28.82, 53.95, 26.66, 63.4, 'Moderate', '2026-07-06 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.02
DO: 5.09 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (402, 14, 7.08, 6.62, 10.76, 29.64, 112.03, 28.16, 55.9, 'Moderate', '2026-07-06 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.08
DO: 6.62 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (403, 14, 7.38, 3.26, 11.18, 13.49, 106.87, 22.25, 34.6, 'Poor', '2026-07-05 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.38
DO: 3.26 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (404, 14, 7.07, 7.61, 5.45, 7.78, 79.07, 22.13, 77.6, 'Moderate', '2026-07-04 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.07
DO: 7.61 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (405, 14, 7.34, 5.74, 5.83, 34.98, 101.23, 22.45, 61.5, 'Moderate', '2026-07-03 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.34
DO: 5.74 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (406, 14, 7.5, 2.83, 8.12, 22.49, 83.46, 22.75, 41.3, 'Poor', '2026-07-01 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.5
DO: 2.83 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (407, 14, 8.18, 6.89, 8.59, 39.2, 49.26, 25.18, 65.3, 'Moderate', '2026-07-01 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 8.18
DO: 6.89 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (408, 14, 6.87, 4.72, 11.8, 8.8, 17.25, 18.94, 55.4, 'Moderate', '2026-06-30 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 6.87
DO: 4.72 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (409, 14, 7.07, 3.59, 3.56, 7.89, 58.5, 21.0, 61.1, 'Moderate', '2026-06-29 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.07
DO: 3.59 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (410, 14, 7.55, 4.76, 5.1, 14.25, 12.12, 30.6, 68.6, 'Moderate', '2026-06-28 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.55
DO: 4.76 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (411, 14, 7.21, 4.85, 5.64, 18.65, 87.28, 27.23, 59.3, 'Moderate', '2026-06-27 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.21
DO: 4.85 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (412, 14, 8.16, 4.52, 11.3, 31.82, 82.23, 23.05, 41.2, 'Poor', '2026-06-25 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 8.16
DO: 4.52 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (413, 14, 6.88, 8.44, 9.54, 24.14, 106.48, 28.67, 67.1, 'Moderate', '2026-06-24 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 6.88
DO: 8.44 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (414, 14, 7.12, 7.14, 2.02, 8.72, 114.11, 22.13, 77.1, 'Moderate', '2026-06-23 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.12
DO: 7.14 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (415, 14, 8.18, 5.37, 4.29, 29.95, 14.99, 29.38, 70.3, 'Moderate', '2026-06-23 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 8.18
DO: 5.37 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (416, 14, 7.32, 2.89, 2.89, 21.07, 46.6, 31.74, 58.8, 'Moderate', '2026-06-22 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.32
DO: 2.89 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (417, 14, 7.56, 7.92, 8.74, 34.78, 18.8, 28.25, 78.2, 'Moderate', '2026-06-20 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.56
DO: 7.92 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (418, 14, 7.89, 5.24, 4.88, 33.26, 55.47, 31.98, 64.2, 'Moderate', '2026-06-20 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.89
DO: 5.24 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (419, 14, 7.5, 7.24, 4.15, 12.16, 48.82, 20.61, 80.3, 'Good', '2026-06-19 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.5
DO: 7.24 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (420, 14, 7.02, 7.87, 6.93, 13.6, 116.96, 23.43, 71.0, 'Moderate', '2026-06-18 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Vijayawada (Prakasam Barrage)
pH: 7.02
DO: 7.87 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (421, 15, 6.87, 7.72, 6.95, 18.91, 49.19, 28.22, 78.9, 'Moderate', '2026-07-16 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 6.87
DO: 7.72 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (422, 15, 7.55, 3.84, 8.21, 27.37, 87.54, 26.62, 46.1, 'Poor', '2026-07-16 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.55
DO: 3.84 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (423, 15, 8.37, 7.29, 6.63, 24.73, 38.85, 19.47, 72.3, 'Moderate', '2026-07-15 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.37
DO: 7.29 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (424, 15, 6.94, 2.97, 7.72, 30.89, 109.14, 25.99, 41.6, 'Poor', '2026-07-14 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 6.94
DO: 2.97 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (425, 15, 7.71, 6.26, 10.21, 21.24, 14.1, 20.31, 65.3, 'Moderate', '2026-07-12 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.71
DO: 6.26 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (426, 15, 6.9, 6.43, 2.42, 5.59, 92.26, 20.97, 75.3, 'Moderate', '2026-07-12 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 6.9
DO: 6.43 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (427, 15, 8.24, 3.65, 6.29, 6.41, 63.17, 18.37, 49.1, 'Poor', '2026-07-11 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.24
DO: 3.65 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (428, 15, 6.98, 3.31, 5.42, 31.61, 17.59, 31.5, 61.3, 'Moderate', '2026-07-10 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 6.98
DO: 3.31 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (429, 15, 8.42, 7.71, 8.78, 35.22, 107.32, 30.53, 60.4, 'Moderate', '2026-07-09 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.42
DO: 7.71 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (430, 15, 8.17, 3.85, 5.76, 17.35, 103.71, 18.3, 46.1, 'Poor', '2026-07-08 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.17
DO: 3.85 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (431, 15, 7.52, 2.4, 11.67, 24.63, 25.78, 25.13, 39.0, 'Poor', '2026-07-06 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.52
DO: 2.4 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (432, 15, 6.81, 2.47, 7.46, 20.76, 73.38, 31.36, 43.5, 'Poor', '2026-07-06 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 6.81
DO: 2.47 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (433, 15, 7.44, 3.05, 5.16, 29.91, 60.75, 25.22, 52.3, 'Moderate', '2026-07-05 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.44
DO: 3.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (434, 15, 7.86, 3.73, 4.73, 36.1, 100.42, 19.11, 49.6, 'Poor', '2026-07-03 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.86
DO: 3.73 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (435, 15, 7.59, 7.81, 2.84, 23.47, 75.9, 23.25, 82.2, 'Good', '2026-07-02 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.59
DO: 7.81 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (436, 15, 7.23, 5.38, 1.9, 32.97, 23.94, 20.32, 79.0, 'Moderate', '2026-07-02 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.23
DO: 5.38 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (437, 15, 7.99, 2.16, 9.73, 8.14, 101.94, 28.6, 28.9, 'Poor', '2026-07-01 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.99
DO: 2.16 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (438, 15, 8.0, 4.63, 8.21, 5.98, 61.59, 22.72, 52.1, 'Moderate', '2026-06-29 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.0
DO: 4.63 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (439, 15, 6.95, 9.47, 5.39, 35.76, 37.13, 18.9, 85.9, 'Good', '2026-06-29 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 6.95
DO: 9.47 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (440, 15, 8.1, 7.82, 5.36, 11.42, 93.84, 31.57, 71.9, 'Moderate', '2026-06-27 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.1
DO: 7.82 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (441, 15, 6.83, 5.6, 8.21, 22.06, 20.39, 24.25, 67.6, 'Moderate', '2026-06-26 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 6.83
DO: 5.6 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (442, 15, 8.06, 7.14, 7.48, 12.59, 78.3, 21.91, 65.7, 'Moderate', '2026-06-25 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.06
DO: 7.14 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (443, 15, 8.43, 4.09, 11.96, 30.55, 114.45, 26.43, 31.5, 'Poor', '2026-06-24 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.43
DO: 4.09 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (444, 15, 7.88, 4.68, 7.75, 7.7, 110.02, 29.39, 47.3, 'Poor', '2026-06-24 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.88
DO: 4.68 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (445, 15, 7.98, 6.21, 3.99, 11.16, 66.21, 23.01, 69.8, 'Moderate', '2026-06-23 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.98
DO: 6.21 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (446, 15, 8.17, 3.55, 3.57, 22.3, 81.36, 19.43, 52.2, 'Moderate', '2026-06-22 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.17
DO: 3.55 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (447, 15, 8.06, 6.13, 3.16, 6.46, 85.25, 23.72, 68.1, 'Moderate', '2026-06-20 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.06
DO: 6.13 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (448, 15, 7.64, 2.67, 2.08, 24.07, 93.9, 22.06, 51.1, 'Moderate', '2026-06-20 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.64
DO: 2.67 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (449, 15, 8.09, 4.36, 11.97, 16.4, 76.62, 27.4, 39.9, 'Poor', '2026-06-18 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 8.09
DO: 4.36 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (450, 15, 7.78, 7.95, 8.52, 6.87, 62.73, 21.16, 71.7, 'Moderate', '2026-06-18 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Amaravati
pH: 7.78
DO: 7.95 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (451, 16, 7.75, 3.01, 11.21, 5.18, 86.76, 24.58, 34.0, 'Poor', '2026-07-17 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.75
DO: 3.01 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (452, 16, 8.11, 8.97, 8.17, 25.73, 17.29, 31.7, 77.4, 'Moderate', '2026-07-16 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 8.11
DO: 8.97 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (453, 16, 8.11, 3.2, 8.59, 18.79, 63.15, 18.8, 42.2, 'Poor', '2026-07-14 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 8.11
DO: 3.2 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (454, 16, 7.67, 2.85, 9.43, 37.62, 75.87, 27.74, 38.8, 'Poor', '2026-07-14 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.67
DO: 2.85 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (455, 16, 7.41, 9.2, 10.55, 19.89, 30.53, 21.44, 74.0, 'Moderate', '2026-07-12 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.41
DO: 9.2 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (456, 16, 8.31, 7.32, 6.77, 30.44, 80.56, 31.52, 66.7, 'Moderate', '2026-07-11 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 8.31
DO: 7.32 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (457, 16, 6.82, 7.69, 4.63, 16.44, 77.59, 24.72, 79.5, 'Moderate', '2026-07-11 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 6.82
DO: 7.69 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (458, 16, 7.95, 4.31, 2.66, 28.63, 37.78, 19.69, 65.6, 'Moderate', '2026-07-10 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.95
DO: 4.31 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (459, 16, 7.11, 2.3, 11.4, 7.5, 21.81, 22.46, 41.6, 'Poor', '2026-07-09 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.11
DO: 2.3 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (460, 16, 8.45, 2.31, 5.54, 26.46, 74.56, 31.1, 40.2, 'Poor', '2026-07-08 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 8.45
DO: 2.31 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (461, 16, 8.02, 4.23, 10.53, 17.17, 106.98, 22.89, 38.4, 'Poor', '2026-07-07 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 8.02
DO: 4.23 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (462, 16, 7.16, 3.75, 11.78, 22.13, 37.91, 26.26, 46.8, 'Poor', '2026-07-05 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.16
DO: 3.75 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (463, 16, 8.45, 7.64, 7.03, 29.38, 52.87, 18.92, 71.1, 'Moderate', '2026-07-05 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 8.45
DO: 7.64 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (464, 16, 7.28, 7.5, 8.57, 16.26, 90.53, 31.08, 67.7, 'Moderate', '2026-07-04 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.28
DO: 7.5 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (465, 16, 7.25, 4.2, 6.49, 22.12, 12.83, 24.0, 63.7, 'Moderate', '2026-07-02 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.25
DO: 4.2 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (466, 16, 8.37, 5.36, 8.56, 11.72, 114.69, 23.07, 46.4, 'Poor', '2026-07-02 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 8.37
DO: 5.36 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (467, 16, 7.96, 9.0, 10.54, 24.17, 14.67, 20.12, 73.4, 'Moderate', '2026-07-01 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.96
DO: 9.0 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (468, 16, 7.84, 2.54, 9.49, 34.99, 106.7, 20.85, 31.7, 'Poor', '2026-06-30 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.84
DO: 2.54 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (469, 16, 7.41, 6.98, 6.71, 6.68, 29.6, 26.38, 76.4, 'Moderate', '2026-06-29 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.41
DO: 6.98 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (470, 16, 6.96, 7.17, 7.0, 33.68, 100.99, 18.39, 68.9, 'Moderate', '2026-06-27 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 6.96
DO: 7.17 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (471, 16, 8.1, 4.72, 4.02, 39.88, 11.46, 30.25, 68.0, 'Moderate', '2026-06-26 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 8.1
DO: 4.72 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (472, 16, 7.13, 2.65, 4.64, 29.48, 44.72, 29.7, 54.9, 'Moderate', '2026-06-26 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.13
DO: 2.65 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (473, 16, 7.78, 7.76, 7.47, 6.76, 58.82, 25.17, 73.4, 'Moderate', '2026-06-25 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.78
DO: 7.76 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (474, 16, 7.09, 4.5, 4.35, 14.93, 35.85, 25.25, 67.7, 'Moderate', '2026-06-24 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.09
DO: 4.5 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (475, 16, 7.48, 8.77, 7.72, 6.18, 31.33, 18.94, 79.6, 'Moderate', '2026-06-22 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.48
DO: 8.77 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (476, 16, 7.09, 7.57, 9.65, 39.16, 86.17, 19.08, 67.3, 'Moderate', '2026-06-22 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.09
DO: 7.57 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (477, 16, 6.97, 3.79, 10.14, 17.49, 70.84, 23.61, 46.6, 'Poor', '2026-06-20 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 6.97
DO: 3.79 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (478, 16, 7.67, 5.93, 3.44, 7.83, 115.25, 28.16, 64.1, 'Moderate', '2026-06-20 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.67
DO: 5.93 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (479, 16, 7.67, 9.43, 1.95, 25.34, 18.61, 26.04, 92.7, 'Good', '2026-06-18 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.67
DO: 9.43 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (480, 16, 7.1, 8.02, 11.48, 29.99, 73.05, 23.66, 67.7, 'Moderate', '2026-06-18 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Jabalpur (Gwarighat)
pH: 7.1
DO: 8.02 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (481, 17, 7.31, 9.19, 5.18, 22.22, 107.04, 22.97, 75.4, 'Moderate', '2026-07-16 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.31
DO: 9.19 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (482, 17, 7.29, 7.72, 5.06, 13.23, 19.46, 25.45, 86.2, 'Good', '2026-07-16 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.29
DO: 7.72 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (483, 17, 8.16, 2.88, 4.52, 5.51, 79.25, 30.39, 46.5, 'Poor', '2026-07-15 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 8.16
DO: 2.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (484, 17, 7.11, 2.76, 8.42, 30.12, 47.57, 18.54, 47.1, 'Poor', '2026-07-14 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.11
DO: 2.76 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (485, 17, 6.85, 3.47, 3.06, 39.62, 115.71, 20.93, 53.1, 'Moderate', '2026-07-13 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 6.85
DO: 3.47 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (486, 17, 7.6, 8.3, 2.7, 35.35, 57.92, 27.03, 86.1, 'Good', '2026-07-12 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.6
DO: 8.3 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (487, 17, 8.11, 3.93, 7.75, 20.44, 29.01, 20.72, 52.9, 'Moderate', '2026-07-11 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 8.11
DO: 3.93 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (488, 17, 7.04, 3.34, 6.22, 12.2, 102.03, 21.78, 48.0, 'Poor', '2026-07-10 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.04
DO: 3.34 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (489, 17, 8.3, 7.43, 8.39, 21.86, 41.84, 18.11, 69.3, 'Moderate', '2026-07-09 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 8.3
DO: 7.43 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (490, 17, 7.21, 2.63, 2.18, 22.45, 20.85, 20.02, 62.9, 'Moderate', '2026-07-07 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.21
DO: 2.63 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (491, 17, 8.34, 6.12, 11.13, 6.71, 56.45, 25.19, 53.5, 'Moderate', '2026-07-07 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 8.34
DO: 6.12 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (492, 17, 7.96, 2.67, 11.66, 33.86, 101.24, 21.14, 28.0, 'Poor', '2026-07-06 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.96
DO: 2.67 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (493, 17, 7.4, 2.55, 7.76, 14.51, 51.68, 22.15, 45.3, 'Poor', '2026-07-05 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.4
DO: 2.55 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (494, 17, 7.17, 8.88, 9.16, 23.61, 46.76, 24.92, 75.9, 'Moderate', '2026-07-04 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.17
DO: 8.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (495, 17, 7.32, 8.54, 4.64, 20.24, 59.71, 30.53, 83.1, 'Good', '2026-07-03 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.32
DO: 8.54 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (496, 17, 7.29, 8.03, 6.82, 26.05, 17.07, 23.89, 84.4, 'Good', '2026-07-01 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.29
DO: 8.03 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (497, 17, 6.97, 7.13, 9.38, 12.44, 19.64, 19.81, 74.8, 'Moderate', '2026-07-01 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 6.97
DO: 7.13 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (498, 17, 7.41, 8.48, 3.83, 34.56, 15.83, 20.6, 90.4, 'Good', '2026-06-30 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.41
DO: 8.48 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (499, 17, 7.23, 8.59, 10.05, 30.57, 105.62, 18.54, 65.6, 'Moderate', '2026-06-28 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.23
DO: 8.59 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (500, 17, 8.11, 5.47, 8.68, 16.41, 83.08, 28.2, 52.5, 'Moderate', '2026-06-28 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 8.11
DO: 5.47 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (501, 17, 8.36, 8.14, 9.34, 36.52, 111.39, 21.51, 60.7, 'Moderate', '2026-06-26 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 8.36
DO: 8.14 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (502, 17, 7.52, 5.97, 3.21, 34.75, 113.39, 20.7, 65.9, 'Moderate', '2026-06-26 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.52
DO: 5.97 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (503, 17, 7.57, 4.65, 6.81, 15.07, 59.94, 20.6, 57.6, 'Moderate', '2026-06-24 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.57
DO: 4.65 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (504, 17, 7.16, 2.33, 6.17, 28.4, 11.03, 22.06, 54.2, 'Moderate', '2026-06-23 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.16
DO: 2.33 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (505, 17, 7.71, 4.4, 3.19, 6.87, 76.85, 29.34, 60.8, 'Moderate', '2026-06-22 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.71
DO: 4.4 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (506, 17, 7.63, 9.49, 3.23, 35.54, 87.83, 21.01, 80.6, 'Good', '2026-06-22 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.63
DO: 9.49 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (507, 17, 8.21, 2.67, 11.54, 13.08, 48.76, 22.23, 34.2, 'Poor', '2026-06-20 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 8.21
DO: 2.67 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (508, 17, 7.39, 4.56, 2.55, 29.46, 10.15, 29.07, 74.0, 'Moderate', '2026-06-19 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.39
DO: 4.56 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (509, 17, 7.21, 4.09, 5.41, 39.24, 32.61, 21.11, 62.9, 'Moderate', '2026-06-18 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.21
DO: 4.09 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (510, 17, 7.8, 7.36, 2.89, 23.54, 68.29, 18.09, 79.5, 'Moderate', '2026-06-18 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Bharuch
pH: 7.8
DO: 7.36 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (511, 18, 7.33, 2.88, 4.8, 32.25, 22.1, 24.14, 58.0, 'Moderate', '2026-07-17 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.33
DO: 2.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (512, 18, 7.72, 9.39, 2.84, 17.92, 108.26, 20.34, 78.2, 'Moderate', '2026-07-16 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.72
DO: 9.39 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (513, 18, 8.34, 3.4, 7.0, 8.12, 35.52, 26.36, 49.4, 'Poor', '2026-07-15 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 8.34
DO: 3.4 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (514, 18, 7.58, 2.5, 3.7, 15.41, 36.8, 19.42, 54.8, 'Moderate', '2026-07-14 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.58
DO: 2.5 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (515, 18, 6.99, 6.19, 8.28, 36.33, 14.47, 27.97, 72.5, 'Moderate', '2026-07-13 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 6.99
DO: 6.19 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (516, 18, 7.07, 2.69, 4.68, 32.49, 88.32, 28.56, 49.3, 'Poor', '2026-07-11 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.07
DO: 2.69 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (517, 18, 8.04, 2.52, 5.23, 21.91, 86.52, 27.28, 42.5, 'Poor', '2026-07-10 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 8.04
DO: 2.52 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (518, 18, 7.93, 2.31, 5.24, 34.5, 82.96, 21.77, 42.3, 'Poor', '2026-07-10 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.93
DO: 2.31 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (519, 18, 7.69, 7.77, 5.64, 18.15, 36.7, 20.88, 80.9, 'Good', '2026-07-08 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.69
DO: 7.77 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (520, 18, 8.41, 4.07, 10.54, 6.08, 25.44, 22.28, 46.8, 'Poor', '2026-07-08 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 8.41
DO: 4.07 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (521, 18, 7.4, 8.53, 9.36, 24.25, 86.86, 25.48, 68.8, 'Moderate', '2026-07-06 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.4
DO: 8.53 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (522, 18, 7.07, 4.33, 6.73, 9.66, 47.02, 29.74, 60.2, 'Moderate', '2026-07-06 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.07
DO: 4.33 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (523, 18, 7.76, 2.91, 3.26, 28.26, 19.35, 27.72, 59.7, 'Moderate', '2026-07-05 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.76
DO: 2.91 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (524, 18, 7.02, 4.13, 7.14, 19.11, 42.33, 21.63, 59.0, 'Moderate', '2026-07-04 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.02
DO: 4.13 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (525, 18, 7.78, 2.19, 5.04, 30.34, 55.21, 19.4, 46.6, 'Poor', '2026-07-03 05:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.78
DO: 2.19 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (526, 18, 7.57, 4.01, 11.19, 20.79, 80.88, 18.02, 41.6, 'Poor', '2026-07-02 07:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.57
DO: 4.01 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (527, 18, 7.72, 2.38, 7.1, 26.91, 47.52, 18.77, 44.7, 'Poor', '2026-07-01 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.72
DO: 2.38 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (528, 18, 7.22, 2.72, 7.77, 5.49, 88.09, 31.04, 42.1, 'Poor', '2026-06-29 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.22
DO: 2.72 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (529, 18, 7.75, 5.04, 2.38, 8.54, 72.81, 19.86, 66.7, 'Moderate', '2026-06-29 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.75
DO: 5.04 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (530, 18, 7.42, 4.93, 10.25, 11.91, 78.38, 27.7, 50.0, 'Moderate', '2026-06-27 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.42
DO: 4.93 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (531, 18, 7.32, 4.12, 2.82, 12.93, 35.93, 25.23, 67.6, 'Moderate', '2026-06-27 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.32
DO: 4.12 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (532, 18, 7.79, 2.53, 3.72, 24.31, 77.82, 28.25, 48.3, 'Poor', '2026-06-25 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.79
DO: 2.53 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (533, 18, 7.22, 4.26, 11.28, 39.96, 43.7, 26.54, 49.7, 'Poor', '2026-06-24 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.22
DO: 4.26 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (534, 18, 7.85, 5.45, 5.87, 10.08, 85.42, 20.75, 59.3, 'Moderate', '2026-06-23 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.85
DO: 5.45 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (535, 18, 7.66, 3.32, 6.69, 8.52, 46.87, 31.75, 51.4, 'Moderate', '2026-06-22 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.66
DO: 3.32 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (536, 18, 7.75, 2.74, 2.58, 25.56, 44.02, 20.58, 56.8, 'Moderate', '2026-06-22 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.75
DO: 2.74 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (537, 18, 7.36, 6.69, 1.74, 37.69, 89.94, 19.34, 77.3, 'Moderate', '2026-06-20 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.36
DO: 6.69 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (538, 18, 8.13, 8.75, 8.56, 11.89, 118.42, 25.89, 62.5, 'Moderate', '2026-06-20 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 8.13
DO: 8.75 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (539, 18, 8.35, 4.86, 2.61, 32.96, 82.51, 18.46, 60.8, 'Moderate', '2026-06-18 20:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 8.35
DO: 4.86 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (540, 18, 7.55, 3.45, 2.87, 12.44, 29.94, 23.7, 63.3, 'Moderate', '2026-06-17 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Srirangapatna
pH: 7.55
DO: 3.45 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (541, 19, 8.03, 5.43, 11.38, 10.26, 58.52, 26.32, 50.2, 'Moderate', '2026-07-16 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.03
DO: 5.43 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (542, 19, 8.42, 6.78, 7.62, 23.49, 77.41, 21.36, 61.6, 'Moderate', '2026-07-15 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.42
DO: 6.78 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (543, 19, 7.79, 4.63, 10.37, 15.69, 119.9, 26.31, 40.5, 'Poor', '2026-07-15 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.79
DO: 4.63 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (544, 19, 7.08, 7.95, 3.61, 15.99, 11.35, 27.68, 92.8, 'Good', '2026-07-13 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.08
DO: 7.95 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (545, 19, 6.81, 5.09, 6.76, 12.58, 11.42, 21.67, 68.8, 'Moderate', '2026-07-12 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 6.81
DO: 5.09 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (546, 19, 8.0, 3.67, 4.13, 8.32, 23.73, 19.06, 60.5, 'Moderate', '2026-07-12 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.0
DO: 3.67 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (547, 19, 8.47, 9.23, 4.15, 36.31, 54.81, 20.89, 79.0, 'Moderate', '2026-07-11 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.47
DO: 9.23 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (548, 19, 7.04, 6.31, 3.92, 9.45, 64.13, 28.42, 75.5, 'Moderate', '2026-07-10 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.04
DO: 6.31 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (549, 19, 7.25, 9.0, 10.78, 16.59, 36.39, 31.62, 73.5, 'Moderate', '2026-07-09 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.25
DO: 9.0 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (550, 19, 8.01, 8.1, 6.27, 31.31, 103.57, 20.01, 70.1, 'Moderate', '2026-07-07 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.01
DO: 8.1 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (551, 19, 7.06, 3.73, 7.73, 9.04, 87.66, 30.53, 49.0, 'Poor', '2026-07-07 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.06
DO: 3.73 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (552, 19, 8.47, 5.12, 2.61, 36.11, 23.43, 19.44, 69.9, 'Moderate', '2026-07-05 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.47
DO: 5.12 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (553, 19, 7.52, 4.22, 6.35, 11.35, 92.17, 27.27, 51.9, 'Moderate', '2026-07-04 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.52
DO: 4.22 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (554, 19, 8.16, 5.24, 3.41, 5.97, 81.83, 20.88, 62.3, 'Moderate', '2026-07-04 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.16
DO: 5.24 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (555, 19, 8.19, 6.81, 4.17, 13.81, 40.6, 21.18, 75.4, 'Moderate', '2026-07-03 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.19
DO: 6.81 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (556, 19, 8.46, 9.15, 7.14, 17.99, 89.58, 21.7, 67.9, 'Moderate', '2026-07-01 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.46
DO: 9.15 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (557, 19, 8.48, 4.85, 3.22, 28.07, 75.08, 29.32, 59.8, 'Moderate', '2026-07-01 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.48
DO: 4.85 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (558, 19, 7.8, 6.7, 7.11, 21.24, 93.21, 25.73, 63.2, 'Moderate', '2026-06-29 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.8
DO: 6.7 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (559, 19, 8.13, 7.31, 5.06, 22.47, 36.59, 21.43, 77.3, 'Moderate', '2026-06-29 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.13
DO: 7.31 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (560, 19, 6.81, 3.38, 3.96, 23.33, 95.93, 28.1, 53.2, 'Moderate', '2026-06-28 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 6.81
DO: 3.38 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (561, 19, 8.34, 8.56, 3.92, 23.13, 28.71, 26.54, 83.8, 'Good', '2026-06-26 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.34
DO: 8.56 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (562, 19, 7.91, 8.77, 11.29, 30.11, 107.71, 23.96, 59.2, 'Moderate', '2026-06-26 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.91
DO: 8.77 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (563, 19, 7.58, 5.28, 8.2, 29.44, 41.18, 30.7, 60.8, 'Moderate', '2026-06-25 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.58
DO: 5.28 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (564, 19, 6.98, 5.69, 4.4, 6.36, 84.8, 28.18, 68.1, 'Moderate', '2026-06-24 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 6.98
DO: 5.69 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (565, 19, 8.33, 6.16, 4.9, 15.55, 106.43, 26.73, 60.3, 'Moderate', '2026-06-23 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.33
DO: 6.16 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (566, 19, 6.88, 5.53, 4.29, 12.14, 74.09, 19.02, 68.4, 'Moderate', '2026-06-22 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 6.88
DO: 5.53 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (567, 19, 7.17, 6.33, 6.39, 15.73, 13.35, 25.36, 76.7, 'Moderate', '2026-06-21 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.17
DO: 6.33 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (568, 19, 8.49, 8.88, 4.88, 37.69, 57.0, 26.92, 77.1, 'Moderate', '2026-06-20 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.49
DO: 8.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (569, 19, 8.32, 8.14, 10.28, 9.62, 30.35, 25.24, 70.0, 'Moderate', '2026-06-18 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 8.32
DO: 8.14 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (570, 19, 7.58, 9.09, 7.83, 34.15, 99.34, 28.72, 69.5, 'Moderate', '2026-06-17 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Tiruchirappalli
pH: 7.58
DO: 9.09 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (571, 20, 8.13, 5.22, 6.06, 7.46, 104.49, 30.11, 53.6, 'Moderate', '2026-07-17 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 8.13
DO: 5.22 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (572, 20, 8.31, 6.02, 2.22, 14.12, 81.71, 24.28, 68.7, 'Moderate', '2026-07-16 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 8.31
DO: 6.02 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (573, 20, 7.4, 7.12, 7.44, 11.19, 110.08, 31.59, 64.6, 'Moderate', '2026-07-15 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.4
DO: 7.12 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (574, 20, 7.49, 2.51, 10.53, 14.75, 15.92, 23.82, 43.6, 'Poor', '2026-07-13 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.49
DO: 2.51 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (575, 20, 6.88, 5.95, 11.82, 20.09, 102.79, 24.96, 50.8, 'Moderate', '2026-07-12 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 6.88
DO: 5.95 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (576, 20, 8.3, 7.88, 6.08, 29.95, 72.4, 22.16, 72.6, 'Moderate', '2026-07-12 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 8.3
DO: 7.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (577, 20, 7.67, 5.47, 4.83, 25.89, 15.48, 23.14, 72.2, 'Moderate', '2026-07-10 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.67
DO: 5.47 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (578, 20, 6.84, 9.17, 9.25, 29.66, 53.14, 28.91, 74.9, 'Moderate', '2026-07-09 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 6.84
DO: 9.17 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (579, 20, 8.2, 2.98, 5.12, 12.78, 119.2, 18.5, 40.1, 'Poor', '2026-07-09 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 8.2
DO: 2.98 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (580, 20, 7.73, 2.95, 6.18, 8.78, 118.46, 27.0, 40.1, 'Poor', '2026-07-07 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.73
DO: 2.95 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (581, 20, 7.83, 3.05, 11.59, 36.5, 28.09, 29.81, 41.1, 'Poor', '2026-07-07 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.83
DO: 3.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (582, 20, 7.89, 2.81, 2.05, 35.78, 28.27, 28.08, 59.8, 'Moderate', '2026-07-05 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.89
DO: 2.81 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (583, 20, 7.14, 8.89, 2.16, 15.69, 91.73, 28.38, 84.9, 'Good', '2026-07-04 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.14
DO: 8.89 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (584, 20, 7.61, 3.07, 5.95, 33.02, 15.85, 27.06, 56.1, 'Moderate', '2026-07-03 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.61
DO: 3.07 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (585, 20, 8.44, 3.82, 9.13, 28.58, 26.77, 21.33, 48.0, 'Poor', '2026-07-02 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 8.44
DO: 3.82 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (586, 20, 7.12, 3.16, 10.94, 29.5, 93.51, 26.07, 37.7, 'Poor', '2026-07-02 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.12
DO: 3.16 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (587, 20, 7.74, 3.05, 11.58, 29.72, 14.67, 26.5, 43.4, 'Poor', '2026-06-30 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.74
DO: 3.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (588, 20, 8.26, 2.71, 5.94, 23.02, 103.19, 27.46, 38.7, 'Poor', '2026-06-30 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 8.26
DO: 2.71 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (589, 20, 7.7, 9.05, 8.81, 34.7, 74.69, 30.14, 70.2, 'Moderate', '2026-06-29 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.7
DO: 9.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (590, 20, 7.61, 7.67, 11.22, 25.67, 56.01, 26.86, 66.1, 'Moderate', '2026-06-27 19:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.61
DO: 7.67 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (591, 20, 7.32, 7.98, 7.63, 18.05, 40.85, 18.51, 79.1, 'Moderate', '2026-06-26 23:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.32
DO: 7.98 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (592, 20, 7.65, 6.58, 6.65, 26.07, 94.9, 23.68, 64.0, 'Moderate', '2026-06-25 21:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.65
DO: 6.58 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (593, 20, 7.7, 5.4, 11.86, 34.53, 76.41, 21.28, 48.2, 'Poor', '2026-06-25 01:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.7
DO: 5.4 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (594, 20, 8.24, 8.35, 9.27, 15.03, 85.32, 30.58, 65.0, 'Moderate', '2026-06-23 22:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 8.24
DO: 8.35 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (595, 20, 7.71, 4.45, 5.5, 35.22, 74.55, 28.64, 56.5, 'Moderate', '2026-06-23 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.71
DO: 4.45 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (596, 20, 8.29, 2.4, 1.86, 8.78, 77.75, 27.65, 49.0, 'Poor', '2026-06-22 00:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 8.29
DO: 2.4 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (597, 20, 7.65, 7.68, 8.76, 26.59, 38.05, 25.97, 73.7, 'Moderate', '2026-06-21 04:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.65
DO: 7.68 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (598, 20, 8.31, 5.0, 3.35, 13.11, 33.47, 30.17, 67.0, 'Moderate', '2026-06-20 02:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 8.31
DO: 5.0 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (599, 20, 7.84, 6.94, 9.67, 35.25, 70.93, 28.46, 61.9, 'Moderate', '2026-06-19 06:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 7.84
DO: 6.94 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (600, 20, 6.9, 3.7, 1.74, 38.28, 93.28, 27.09, 60.7, 'Moderate', '2026-06-18 03:27:19.657312', 'https://cpcb.nic.in/water-quality/', 'Station: Guwahati
pH: 6.9
DO: 3.7 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (601, 21, 7.57, 7.2, 2.46, 16.55, 109.16, 19.77, 75.0, 'Moderate', '2026-07-17 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.57
DO: 7.2 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (602, 21, 8.05, 5.43, 4.97, 24.32, 85.8, 29.56, 60.1, 'Moderate', '2026-07-16 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 8.05
DO: 5.43 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (603, 21, 7.47, 7.78, 1.79, 26.23, 65.3, 28.44, 86.4, 'Good', '2026-07-14 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.47
DO: 7.78 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (604, 21, 6.85, 3.27, 9.44, 30.99, 113.32, 20.42, 38.6, 'Poor', '2026-07-13 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 6.85
DO: 3.27 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (605, 21, 8.24, 5.88, 3.51, 14.66, 108.66, 19.02, 61.8, 'Moderate', '2026-07-12 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 8.24
DO: 5.88 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (606, 21, 7.3, 2.8, 7.96, 7.67, 114.0, 23.71, 38.2, 'Poor', '2026-07-12 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.3
DO: 2.8 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (607, 21, 7.91, 6.68, 6.81, 20.76, 111.35, 22.86, 60.6, 'Moderate', '2026-07-10 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.91
DO: 6.68 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (608, 21, 7.69, 5.16, 4.49, 22.37, 95.36, 20.96, 60.0, 'Moderate', '2026-07-10 00:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.69
DO: 5.16 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (609, 21, 7.74, 6.31, 7.67, 26.7, 21.61, 21.51, 69.9, 'Moderate', '2026-07-08 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.74
DO: 6.31 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (610, 21, 8.16, 3.94, 7.67, 11.61, 37.94, 29.4, 51.7, 'Moderate', '2026-07-08 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 8.16
DO: 3.94 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (611, 21, 7.29, 4.38, 8.1, 5.06, 104.92, 21.29, 48.4, 'Poor', '2026-07-07 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.29
DO: 4.38 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (612, 21, 7.19, 8.05, 2.0, 8.84, 64.4, 20.26, 88.7, 'Good', '2026-07-06 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.19
DO: 8.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (613, 21, 7.33, 8.94, 5.39, 15.24, 12.33, 21.32, 87.9, 'Good', '2026-07-05 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.33
DO: 8.94 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (614, 21, 7.33, 6.4, 5.77, 23.51, 93.29, 25.06, 66.6, 'Moderate', '2026-07-04 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.33
DO: 6.4 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (615, 21, 7.18, 8.92, 11.62, 39.76, 49.24, 22.47, 70.2, 'Moderate', '2026-07-03 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.18
DO: 8.92 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (616, 21, 7.33, 5.95, 3.98, 17.31, 65.07, 26.55, 71.7, 'Moderate', '2026-07-01 21:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.33
DO: 5.95 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (617, 21, 7.96, 9.05, 8.17, 6.13, 87.87, 24.27, 68.4, 'Moderate', '2026-07-01 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.96
DO: 9.05 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (618, 21, 7.45, 7.76, 10.42, 11.33, 33.22, 24.97, 72.3, 'Moderate', '2026-06-29 20:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.45
DO: 7.76 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (619, 21, 7.24, 6.22, 3.78, 26.82, 92.78, 19.95, 70.4, 'Moderate', '2026-06-29 03:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.24
DO: 6.22 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (620, 21, 7.44, 8.74, 6.71, 12.27, 116.36, 30.03, 70.2, 'Moderate', '2026-06-28 06:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.44
DO: 8.74 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (621, 21, 7.47, 9.07, 6.71, 17.53, 78.51, 26.93, 75.3, 'Moderate', '2026-06-26 23:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.47
DO: 9.07 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (622, 21, 7.13, 6.87, 5.54, 9.82, 26.41, 27.1, 80.1, 'Good', '2026-06-26 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.13
DO: 6.87 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (623, 21, 7.86, 6.54, 9.98, 33.25, 54.0, 19.05, 61.2, 'Moderate', '2026-06-25 01:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.86
DO: 6.54 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (624, 21, 8.04, 8.02, 9.55, 29.27, 23.01, 21.21, 74.0, 'Moderate', '2026-06-24 05:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 8.04
DO: 8.02 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (625, 21, 8.33, 6.11, 7.84, 18.24, 56.69, 30.3, 60.5, 'Moderate', '2026-06-23 07:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 8.33
DO: 6.11 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (626, 21, 8.45, 4.13, 6.51, 27.21, 48.91, 20.88, 52.3, 'Moderate', '2026-06-22 04:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 8.45
DO: 4.13 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (627, 21, 7.0, 5.66, 4.72, 38.89, 99.31, 19.16, 65.4, 'Moderate', '2026-06-20 22:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.0
DO: 5.66 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (628, 21, 7.66, 8.74, 3.38, 36.38, 39.99, 26.35, 86.8, 'Good', '2026-06-19 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 7.66
DO: 8.74 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (629, 21, 6.92, 8.34, 2.95, 18.39, 52.2, 30.66, 88.9, 'Good', '2026-06-19 02:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 6.92
DO: 8.34 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');
INSERT INTO "water_quality_readings" ("id", "station_id", "ph", "dissolved_oxygen_mg_l", "bod_mg_l", "cod_mg_l", "turbidity_ntu", "temperature_c", "wqi", "quality_class", "recorded_at", "source_url", "raw_text", "validated_at", "created_at") VALUES (630, 21, 8.13, 9.0, 2.58, 33.27, 44.01, 30.73, 85.6, 'Good', '2026-06-17 19:27:19.657312', 'https://indiawris.gov.in/', 'Station: Dibrugarh
pH: 8.13
DO: 9.0 mg/L
', '2026-07-17 07:27:20', '2026-07-17 07:27:20');

SELECT setval(pg_get_serial_sequence('monitoring_stations', 'id'), COALESCE((SELECT MAX(id) FROM "monitoring_stations"), 1), true);
SELECT setval(pg_get_serial_sequence('saas_clients', 'id'), COALESCE((SELECT MAX(id) FROM "saas_clients"), 1), true);
SELECT setval(pg_get_serial_sequence('validation_logs', 'id'), COALESCE((SELECT MAX(id) FROM "validation_logs"), 1), true);
SELECT setval(pg_get_serial_sequence('water_quality_readings', 'id'), COALESCE((SELECT MAX(id) FROM "water_quality_readings"), 1), true);
