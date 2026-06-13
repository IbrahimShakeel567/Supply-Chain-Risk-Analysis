CREATE TABLE supply_chain_risk (
    shipment_id VARCHAR(50) PRIMARY KEY,
    shipment_date DATE,
    origin_port VARCHAR(100),
    destination_port VARCHAR(100),
    transport_mode VARCHAR(50),
    product_category VARCHAR(100),
    distance_km NUMERIC(10, 2),
    weight_mt NUMERIC(10, 2),
    fuel_price_index NUMERIC(5, 2),
    geopolitical_risk_score NUMERIC(4, 1),
    weather_condition VARCHAR(50),
    carrier_reliability_score NUMERIC(4, 3),
    lead_time_days NUMERIC(6, 2),
    disruption_occurred INT
);

--Checking for Null Values
SELECT 
    COUNT(*) - COUNT(shipment_id) AS missing_ids,
    COUNT(*) - COUNT(origin_port) AS missing_origins,
    COUNT(*) - COUNT(lead_time_days) AS missing_lead_times,
    COUNT(*) - COUNT(carrier_reliability_score) AS missing_scores
FROM supply_chain_risk;

--Duplicates?
SELECT shipment_id, COUNT(*)
FROM supply_chain_risk
GROUP BY shipment_id
HAVING COUNT(*) > 1;

--Check Validity
SELECT 
    MIN(lead_time_days) AS min_lead_time,
    MAX(lead_time_days) AS max_lead_time,
    MIN(carrier_reliability_score) AS min_reliability,
    MAX(carrier_reliability_score) AS max_reliability,
    MIN(distance_km) AS min_distance
FROM supply_chain_risk;

--Checking for Consistency
SELECT DISTINCT origin_port 
FROM supply_chain_risk 
ORDER BY origin_port;

--Bottle Neck Analysis
SELECT 
    origin_port,
    destination_port,
    COUNT(shipment_id) AS total_shipments,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time_days,
    ROUND(AVG(distance_km), 2) AS avg_distance_km,
    SUM(disruption_occurred) AS total_disruptions,
    ROUND((SUM(disruption_occurred)::NUMERIC / COUNT(shipment_id)) * 100, 2) AS disruption_rate_percent
FROM supply_chain_risk
GROUP BY origin_port, destination_port
ORDER BY disruption_rate_percent DESC;

--Transport Mode & Carrier Reliability Matrix
SELECT 
    transport_mode,
    COUNT(shipment_id) AS shipment_count,
    ROUND(SUM(weight_mt), 2) AS total_weight_moved_mt,
    ROUND(AVG(carrier_reliability_score), 3) AS avg_carrier_reliability,
    ROUND((SUM(disruption_occurred)::NUMERIC / COUNT(shipment_id)) * 100, 2) AS disruption_rate_percent
FROM supply_chain_risk
GROUP BY transport_mode
ORDER BY total_weight_moved_mt DESC;

--Weather Induced Lead Time Variance (Impact Analysis)
SELECT 
    weather_condition,
    COUNT(shipment_id) AS total_shipments,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time_days,
    ROUND(AVG(fuel_price_index), 2) AS avg_fuel_price_index,
    SUM(disruption_occurred) AS total_disruptions
FROM supply_chain_risk
GROUP BY weather_condition
ORDER BY avg_lead_time_days DESC;

--Advanced Route Risk Ranking (Window Function)
SELECT 
    transport_mode,
    product_category,
    ROUND(AVG(geopolitical_risk_score), 2) AS avg_geopolitical_risk,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time_days,
    DENSE_RANK() OVER (
        PARTITION BY transport_mode 
        ORDER BY AVG(geopolitical_risk_score) DESC
    ) AS risk_rank_within_mode
FROM supply_chain_risk
GROUP BY transport_mode, product_category;