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

### 1. The Climate-Vector Threshold Correlation
The execution of our high-heat and heavy rainfall analytical threshold filters confirmed that vector-borne pathogens respond strongly to specific climate triggers. Months logging sustained average temperatures above **25.0°C** paired with severe rainfall scaling beyond **150.0mm** systematically registered the highest outbreaks in the dataset.

### 2. Macro Budget Tier Performance Outcomes
The database partitioned regions globally into two financial tiers based on a dynamic statistical mean baseline. The results revealed a stark operational insight:
*   **Low Budget Regions** logged an exponentially higher overall monthly average case rate.
*   **High Budget Regions** displayed stabilized transmission rates. This confirms that regional public healthcare budgets play a critical role in mitigating vector outbreaks during high-risk weather seasons.

### 3. Ingestion Pipeline Performance
*   **Target Rows Extracted:** 34,560
*   **Corrupted Data Points Cleaned/Dropped:** 0 (Achieved 100% data fidelity through decimal-safe casting strategies).

---

## 🏁 Conclusions & Repository Applications
Project 2 demonstrates that moving data from flat spreadsheets to an optimized relational server is vital for large-scale environmental tracking. By using advanced data validation checks, this pipeline successfully turned 34,560 raw text rows into a reliable analytics database. 

The saved database View layer (`v_climate_epidemiology_dashboard`) removes the need for tedious manual data preparation. This allows data scientists and public health officials to write clean queries, connect real-time visualization dashboards, and easily extract actionable medical insights from the climate data.

