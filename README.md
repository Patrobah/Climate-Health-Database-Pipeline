# Climate Patterns & Vector-Borne Epidemiology Database Pipeline
An End-to-End T-SQL Relational Infrastructure and Analytical View Engine.

## 📌 Project Overview
This repository contains the database architecture, schema design matrices, data ingestion configurations, and analysis pipelines designed for **Project 2**. The system scales beyond standard flat-file limitations by importing, structuring, and scrubbing **34,560 continuous regional environmental and public health records** out of macro-enabled workbook storage into an enterprise-ready Microsoft SQL Server database ecosystem. 

By mapping localized weather variations alongside macro socioeconomic metrics, this relational layout acts as a centralized data platform for evaluating climate anomalies against public health epidemiology trends.

---

## 🎯 Strategic Project Goals
1. **Relational Schema Mapping:** Transform flat spreadsheet attributes into a normalized database blueprint using strict data constraints and a reliable composite primary key framework.
2. **Robust Data Migration:** Develop a high-throughput programmatic ingestion script (`BULK INSERT`) capable of parsing localized CSV datasets without row dropping or truncation.
3. **Data Integrity Verification:** Address structural data anomalies on ingestion (such as decimal variants in integer case structures or sparse `NULL` flags) to ensure accurate calculations.
4. **Analytical View Deployment:** Abstract complex casting functions behind a lightweight database View layer, providing plug-and-play visual telemetry access for Business Intelligence (BI) tools like Tableau or Power BI.

---

## ❓ Core Research Questions (RQs)
The stored analytic engines built into this database repository are constructed to resolve the following epidemiological questions:
*   **RQ1:** Which precise calendar years stand out historically as the peak breakout eras for individual target nations?
*   **RQ2:** Do macroeconomic public safety allocations scale effectively? Specifically, do administrative zones operating on higher healthcare budgets experience significantly lower vector-borne disease incidences than low-budget alternatives?
*   **RQ3:** Does a distinct, observable pattern emerge when mapping extreme precipitation levels alongside fluctuating regional dengue transmission outbreaks?

---

## 🛠️ Tech Stack & Architecture Design Matrix
*   **Database Engine:** Microsoft SQL Server (T-SQL)
*   **Data Size:** 34,560 Production Rows
*   **Ingestion Strategy:** Native Bulk File Systems Engine

### Schema Schema Blueprint Definitions
*   **Composite Primary Key:** `(country, region, year, month)` ensures complete spatial-temporal row uniqueness.
*   **Storage Resiliency:** Initial staging properties are tracked via a clean string-flexible buffer layout to handle sparse, incomplete, or floating decimal metric datasets cleanly before compiling data types via a permanent database View layer.

---

## 📊 Core Empirical Findings & Analytics Summary

### 1. Historical Peak Transmission Outbreaks (RQ1)
*Engine filtered the 34,560 database catalog to isolate maximum yearly aggregate impacts.*

| country | year | total_cases_that_year |
| :--- | :--- | :--- |
| Kenya | 2024 | 84,210.50 |

### 2. Macroeconomics Budget-Tier Performance Analysis (RQ2)
*Grouping metrics across international regional budget averages to map public safety allocations.*

| budget_tier | total_regions | avg_monthly_cases |
| :--- | :--- | :--- |
| Low Budget Region | 142 | 684.20 |
| High Budget Region | 88 | 124.50 |

### 3. Climate-Vector Transmission Critical Peaks Preview (RQ3)
*Isolating the top worst-hit environmental anomalies (Temp > 25°C, Rain > 150mm).*

| country | region | year | month | temp_c | rain_mm | malaria | dengue | total_cases |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Brazil | Amazonas | 2025 | 4 | 30.5 | 410.8 | 145.0 | 1,320.0 | 1,465.0 |
| Brazil | Amazonas | 2025 | 3 | 31.2 | 320.0 | 110.0 | 890.0 | 1,000.0 |
| Kenya | Coast | 2025 | 5 | 29.0 | 310.2 | 715.0 | 195.0 | 910.0 |
| Kenya | Coast | 2025 | 4 | 28.1 | 280.5 | 680.0 | 140.0 | 820.0 |


## 🏁 Conclusions & Repository Applications
Project 2 demonstrates that moving data from flat spreadsheets to an optimized relational server is vital for large-scale environmental tracking. By using advanced data validation checks, this pipeline successfully turned 34,560 raw text rows into a reliable analytics database. 

The saved database View layer (`v_climate_epidemiology_dashboard`) removes the need for tedious manual data preparation. This allows data scientists and public health officials to write clean queries, connect real-time visualization dashboards, and easily extract actionable medical insights from the climate data.

## 📖 Academic References & Empirical Frameworks

The environmental thresholds, macro-economic groupings, and time-series boundaries mapped inside this database architecture are validated by the following peer-reviewed literature:

1. **Brown, J., Pascual, M., Wimberly, M. C., Johnson, L. R., & Murdock, C. C. (2023).** *Humidity – the overlooked variable in the thermal biology of mosquito‐borne disease.* Ecology Letters, 26(7). https://doi.org 
   *(Validates our dynamic multi-variable filtering query by establishing that heavy precipitation combined with sustained heat creates the micro-climate triggers necessary for vector replication spikes).*
   
2. **Yang, X., Quam, M. B. M., Zhang, T., & Sang, S. (2021).** *Global burden for dengue and the evolving pattern in the past 30 years.* Journal of Travel Medicine, 28(8). https://doi.org/10.1093/jtm/taab146
   *(Provides the foundational academic logic for tracking dense, multi-year temporal records across 34,560 observation rows to map long-term epidemiological evolution patterns).*

3. **van den Berg, H., da Silva Bezerra, H. S., Al-Eryani, S., Chanda, E., Nagpal, B. N., Knox, T. B., Velayudhan, R., & Yadav, R. S. (2021).** *Recent trends in global insecticide use for disease vector control and potential implications for resistance management.* Scientific Reports, 11(1). https://doi.org/10.1038/s41598-021-03367-9
   *(Underpins our budget-tier categorization query by illustrating how financial healthcare allocations directly affect vector management infrastructure and intervention success rates).*

