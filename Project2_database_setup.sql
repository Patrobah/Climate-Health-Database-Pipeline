CREATE DATABASE ClimateHealthDB;
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

--Uploading CSV file fropm PC
);
BULK INSERT climate_health_records
FROM 'C:\Projects\Excel Project 1\Data_Master_Clean.csv'
WITH (
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '\n',      
    FIRSTROW = 2               
);
--first 50 raws of the data
SELECT COUNT(*) AS total_imported_rows FROM climate_health_records;
SELECT TOP 50 * FROM climate_health_records;

--top 10 worst months for malaria
SELECT TOP 10 
    country, 
    region, 
    [year], 
    [month], 
    TRY_CAST(malaria_cases AS INT) AS clean_malaria_cases
FROM 
    climate_health_records
ORDER BY 
    clean_malaria_cases DESC;

--The Climate Vector Risk Query
SELECT TOP 20
    country,
    region,
    [year],
    [month],
    -- Cleanly read metrics as decimal numbers
    TRY_CAST(avg_temp_c AS NUMERIC(4,1)) AS temp_c,
    TRY_CAST(precipitation_mm AS NUMERIC(6,1)) AS rain_mm,
    
    -- Cleanly read disease metrics as whole integers
    TRY_CAST(malaria_cases AS INT) AS malaria,
    TRY_CAST(dengue_cases AS INT) AS dengue,
    
    -- Dynamically calculate total outbreaks
    (ISNULL(TRY_CAST(malaria_cases AS INT), 0) + ISNULL(TRY_CAST(dengue_cases AS INT), 0)) AS total_cases
FROM 
    climate_health_records
WHERE 
    TRY_CAST(avg_temp_c AS NUMERIC(4,1)) > 25.0  -- High Heat Threshold
    AND TRY_CAST(precipitation_mm AS NUMERIC(6,1)) > 150.0  -- Heavy Rainfall Threshold
ORDER BY 
    total_cases DESC;

--Data Validation Audit
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(malaria_cases AS INT) IS NULL THEN 1 ELSE 0 END) AS messy_malaria_rows,
    SUM(CASE WHEN TRY_CAST(dengue_cases AS INT) IS NULL THEN 1 ELSE 0 END) AS messy_dengue_rows,
    SUM(CASE WHEN TRY_CAST(precipitation_mm AS NUMERIC(6,1)) IS NULL THEN 1 ELSE 0 END) AS messy_rain_rows
FROM 
    climate_health_records;

--Analytics View
CREATE VIEW v_climate_epidemiology_dashboard AS
SELECT 
    country,
    region,
    [year],
    [month],
    -- Cast text columns directly to clear numeric fields since data is verified clean
    CAST(avg_temp_c AS NUMERIC(4,1)) AS average_temperature_c,
    CAST(precipitation_mm AS NUMERIC(6,1)) AS total_rainfall_mm,
    CAST(air_quality_index AS INT) AS aqi,
    CAST(uv_index AS INT) AS uv,
    
    -- Public Health Calculations
    CAST(malaria_cases AS INT) AS malaria_cases,
    CAST(dengue_cases AS INT) AS dengue_cases,
    (CAST(malaria_cases AS INT) + CAST(dengue_cases AS INT)) AS combined_disease_burden,
    
    -- Demographics
    CAST(population_density AS NUMERIC(10,2)) AS pop_density,
    CAST(healthcare_budget AS NUMERIC(15,2)) AS allocated_budget
FROM 
    climate_health_records;

    --testing the new view
SELECT TOP 10 * 
FROM v_climate_epidemiology_dashboard 
WHERE combined_disease_burden > 50
ORDER BY total_rainfall_mm DESC;

ALTER VIEW v_climate_epidemiology_dashboard AS
SELECT 
    country,
    region,
    [year],
    [month],
    -- Cast metrics to decimals
    CAST(avg_temp_c AS NUMERIC(10,2)) AS average_temperature_c,
    CAST(precipitation_mm AS NUMERIC(10,2)) AS total_rainfall_mm,
    CAST(air_quality_index AS NUMERIC(10,2)) AS aqi,
    CAST(uv_index AS NUMERIC(10,2)) AS uv,
    
    -- Fix: Read case columns as decimals/floats first so it doesn't crash on numbers like 6.54
    CAST(malaria_cases AS NUMERIC(10,2)) AS malaria_cases,
    CAST(dengue_cases AS NUMERIC(10,2)) AS dengue_cases,
    
    -- Calculate combined burden using decimal-safe math
    (CAST(malaria_cases AS NUMERIC(10,2)) + CAST(dengue_cases AS NUMERIC(10,2))) AS combined_disease_burden,
    
    -- Demographics
    CAST(population_density AS NUMERIC(10,2)) AS pop_density,
    CAST(healthcare_budget AS NUMERIC(15,2)) AS allocated_budget
FROM 
    climate_health_records;


-- A baseline validation query that pulls the actual top 10 highest outbreak months in your dataset
SELECT TOP 10 
    country, 
    region, 
    [year], 
    [month], 
    total_rainfall_mm, 
    combined_disease_burden
FROM 
    v_climate_epidemiology_dashboard
ORDER BY 
    combined_disease_burden DESC;

--The Deadliest Year on Record (Example: Kenya)
SELECT TOP 1
    country,
    [year],
    SUM(combined_disease_burden) AS total_cases_that_year
FROM 
    v_climate_epidemiology_dashboard
WHERE 
    country = 'Kenya'  -- You can swap 'Kenya' out for any country in your dataset
GROUP BY 
    country, [year]
ORDER BY 
    total_cases_that_year DESC;

--High-Budget vs. Low-Budget Regional Case Breakdown
WITH BudgetThreshold AS (
    -- 1. Calculate the baseline average budget across the dataset
    SELECT AVG(allocated_budget) AS avg_global_budget FROM v_climate_epidemiology_dashboard
),
CategorizedRegions AS (
    -- 2. Label each row cleanly using the threshold value
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
-- 3. Group and aggregate by the pre-calculated label
SELECT 
    budget_tier,
    COUNT(DISTINCT region) AS total_regions,
    AVG(combined_disease_burden) AS avg_monthly_cases
FROM 
    CategorizedRegions
GROUP BY 
    budget_tier;


--Rainfall to Dengue Case Extraction
SELECT 
    country,
    region,
    [year],
    [month],
    total_rainfall_mm,
    dengue_cases
FROM 
    v_climate_epidemiology_dashboard
WHERE 
    total_rainfall_mm IS NOT NULL 
    AND dengue_cases IS NOT NULL
ORDER BY 
    total_rainfall_mm DESC;


