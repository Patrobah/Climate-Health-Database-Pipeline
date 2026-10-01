-- =========================================================================
-- PROJECT 2: CLIMATE PATTERNS & VECTOR-BORNE EPIDEMIOLOGY DATA PIPELINE
-- Engine: Microsoft SQL Server (T-SQL)
-- Records Managed: 34,560 Monthly Regional Environmental Logs
-- =========================================================================

-- 1. DATABASE INIT & ARCHITECTURE DEFINITION
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ClimateHealthDB')
BEGIN
    CREATE DATABASE ClimateHealthDB;
END;
GO

USE ClimateHealthDB;
GO

-- Re-create the staging architecture to absorb text, decimals, or missing metrics risk-free
DROP TABLE IF EXISTS climate_health_records;
CREATE TABLE climate_health_records (
    [year] INT NOT NULL,
    [month] INT NOT NULL,
    country VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    avg_temp_c VARCHAR(100) NULL,
    precipitation_mm VARCHAR(100) NULL,
    air_quality_index VARCHAR(100) NULL,
    uv_index VARCHAR(100) NULL,
    malaria_cases VARCHAR(100) NULL,
    dengue_cases VARCHAR(100) NULL,
    population_density VARCHAR(100) NULL,
    healthcare_budget VARCHAR(100) NULL,
    
    PRIMARY KEY (country, region, [year], [month])
);
GO

-- 2. AUTOMATED BULK DATA MIGRATION INGESTION
BULK INSERT climate_health_records
FROM 'C:\Projects\Excel Project 1\Data_Master_Clean.csv'
WITH (
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '\n',      
    FIRSTROW = 2               
);
GO

-- 3. POST-MIGRATION DATA INTEGRITY AUDITS
SELECT COUNT(*) AS total_imported_rows FROM climate_health_records;
SELECT TOP 50 * FROM climate_health_records;

-- Pipeline integrity assessment (Checking for unconvertible anomalies)
SELECT 
    COUNT(*) AS total_audited_rows,
    SUM(CASE WHEN TRY_CAST(malaria_cases AS NUMERIC(10,2)) IS NULL THEN 1 ELSE 0 END) AS invalid_malaria_rows,
    SUM(CASE WHEN TRY_CAST(dengue_cases AS NUMERIC(10,2)) IS NULL THEN 1 ELSE 0 END) AS invalid_dengue_rows,
    SUM(CASE WHEN TRY_CAST(precipitation_mm AS NUMERIC(10,2)) IS NULL THEN 1 ELSE 0 END) AS invalid_rain_rows
FROM 
    climate_health_records;
GO

-- 4. ANALYTICS PIPELINE & PRODUCTION VIEW LAYER GENERATION
-- Safely handle sub-unit fractions (e.g. 6.54 cases) by standardising via decimal matrices
CREATE OR ALTER VIEW v_climate_epidemiology_dashboard AS
SELECT 
    country,
    region,
    [year],
    [month],
    CAST(avg_temp_c AS NUMERIC(10,2)) AS average_temperature_c,
    CAST(precipitation_mm AS NUMERIC(10,2)) AS total_rainfall_mm,
    CAST(air_quality_index AS NUMERIC(10,2)) AS aqi,
    CAST(uv_index AS NUMERIC(10,2)) AS uv,
    CAST(malaria_cases AS NUMERIC(10,2)) AS malaria_cases,
    CAST(dengue_cases AS NUMERIC(10,2)) AS dengue_cases,
    (CAST(malaria_cases AS NUMERIC(10,2)) + CAST(dengue_cases AS NUMERIC(10,2))) AS combined_disease_burden,
    CAST(population_density AS NUMERIC(10,2)) AS pop_density,
    CAST(healthcare_budget AS NUMERIC(15,2)) AS allocated_budget
FROM 
    climate_health_records;
GO

-- 5. PRODUCTION ANALYTICS QUERIES (RESEARCH GOAL RESOLUTION)

-- [Test Query]: View validation isolating mid-tier burdens ordered by extreme rain
SELECT TOP 10 * 
FROM v_climate_epidemiology_dashboard 
WHERE combined_disease_burden > 50
ORDER BY total_rainfall_mm DESC;

-- [Query 1]: High-Risk Transmission Outbreaks (Malaria focus)
SELECT TOP 10 
    country, region, [year], [month], malaria_cases
FROM 
    v_climate_epidemiology_dashboard
ORDER BY 
    malaria_cases DESC;

-- [Query 2]: Climate-Vector Multi-Variable Extremes 
SELECT TOP 20
    country, region, [year], [month],
    average_temperature_c AS temp_c,
    total_rainfall_mm AS rain_mm,
    malaria_cases AS malaria,
    dengue_cases AS dengue,
    combined_disease_burden AS total_cases
FROM 
    v_climate_epidemiology_dashboard
WHERE 
    average_temperature_c > 25.0  
    AND total_rainfall_mm > 150.0  
ORDER BY 
    combined_disease_burden DESC;

-- [Query 3]: Historical Outbreak Peak (Deadliest year per target country - Example: Kenya)
SELECT TOP 1
    country,
    [year],
    SUM(combined_disease_burden) AS total_cases_that_year
FROM 
    v_climate_epidemiology_dashboard
WHERE 
    country = 'Kenya'  
GROUP BY 
    country, [year]
ORDER BY 
    total_cases_that_year DESC;

-- [Query 4]: Macroeconomics Health Analysis (High vs Low Budget Breakdown)
WITH BudgetThreshold AS (
    SELECT AVG(allocated_budget) AS avg_global_budget FROM v_climate_epidemiology_dashboard
),
CategorizedRegions AS (
    SELECT 
        region,
        combined_disease_burden,
        CASE 
            WHEN allocated_budget >= (SELECT avg_global_budget FROM BudgetThreshold) THEN 'High Budget Region'
            ELSE 'Low Budget Region'
        END AS budget_tier
    FROM 
        v_climate_epidemiology_dashboard
)
SELECT 
    budget_tier,
    COUNT(DISTINCT region) AS total_regions,
    AVG(combined_disease_burden) AS avg_monthly_cases
FROM 
    CategorizedRegions
GROUP BY 
    budget_tier;

-- [Query 5]: Bivariate Extraction Patterning (Rainfall to Dengue Distribution)
SELECT 
    country, region, [year], [month], total_rainfall_mm, dengue_cases
FROM 
    v_climate_epidemiology_dashboard
WHERE 
    total_rainfall_mm IS NOT NULL 
    AND dengue_cases IS NOT NULL
ORDER BY 
    total_rainfall_mm DESC;
GO
