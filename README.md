# Supply-Chain-Risk-Analysis
End-to-end supply chain analytics project. Engineered a PostgreSQL backend to ingest and clean global logistics data, and developed an interactive Power BI executive dashboard to analyze transit lead times, weather risks, and carrier reliability.

# Global Supply Chain Risk & Logistics Analytics

An end-to-end data analytics project demonstrating data engineering, backend database management, and business intelligence. This project ingests raw, unstructured global logistics data into a relational database, applies rigorous SQL data-cleaning methodologies, and visualizes key operational metrics through an interactive Power BI executive dashboard.

## 🏢 Project Architecture
* **Data Source:** Raw CSV containing global shipment records, transit times, weather conditions, and risk metrics.
* **Database Layer:** PostgreSQL (pgAdmin 4) for schema design, data cleaning, and analytical queries.
* **Visualization Layer:** Power BI Desktop connected directly to the local PostgreSQL instance via an optimized query pipeline.

---

## 🛠️ Key Features & Technical Work

### 1. Database Engineering & Optimization (SQL)
* Designed and implemented the relational schema for the `supply_chain_risk` database.
* Engineered backend SQL scripts to handle real-world warehouse data anomalies, including:
  * Standardizing textual inconsistencies and white spaces using `TRIM()` and `UPPER()`.
  * Preserving data integrity by handling missing data points with `COALESCE()`.
  * Rectifying boundary data-entry errors (e.g., impossible negative transit lead times) using conditional logic (`CASE WHEN`) and mathematical adjustments (`ABS`).

### 2. Executive Dashboard Design (Power BI)
* Created a clean, high-end corporate user interface aligned with standard corporate design patterns.
* Built dynamic, high-level KPI cards to track core supply chain metrics: **Total Consignments Monitored**, **Average Transit Lead Time (Days)**, and **Global Disruption Incident Rates**.
* Developed a responsive **Weather-Condition Slicer** allowing logistics managers to dynamically filter data and assess the impact of severe weather on specific shipping lanes.
* Replaced traditional, low-density visuals with an optimized **Transit Lead Time Variance Column Chart** to clearly rank disruptions and bottleneck risk.
* Built a tabular **Shipping Corridor Performance Matrix** to deliver granular route summaries (`Origin` vs. `Destination`) at a glance.

---

## 📊 Sample SQL Query (Data Cleaning Layer)

```sql
SELECT 
    shipment_id,
    UPPER(TRIM(origin_port)) AS cleaned_origin_port,
    destination_port,
    transport_mode,
    COALESCE(carrier_reliability_score, 0.000) AS cleaned_reliability_score,
    CASE 
        WHEN lead_time_days < 0 THEN ABS(lead_time_days)
        ELSE COALESCE(lead_time_days, 0)
    END AS cleaned_lead_time_days,
    disruption_occurred
FROM supply_chain_risk;
