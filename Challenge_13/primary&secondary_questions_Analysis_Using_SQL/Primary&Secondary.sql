-- 1. Top and Bottom Performing Cities
-- Top 3 Performing Cities by Total Trips
SELECT 
    dim_city.city_name,
    SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
    fact_passenger_summary
JOIN 
    dim_city ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name
ORDER BY 
    total_trips DESC
LIMIT 3;
-- Bottom 3 Performing Cities by Total Trips

SELECT 
    dim_city.city_name,
    SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
    fact_passenger_summary
JOIN 
    dim_city ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name
ORDER BY 
    total_trips ASC
LIMIT 3;


-- alternative 

(SELECT 
    city_name,
    SUM(fact_passenger_summary.total_passengers) AS total_trips,
    'Top 3' AS performance
FROM 
    fact_passenger_summary
JOIN 
    dim_city ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name
ORDER BY 
    total_trips DESC
LIMIT 3)

UNION ALL

(SELECT 
    city_name,
    SUM(fact_passenger_summary.total_passengers) AS total_trips,
    'Bottom 3' AS performance
FROM 
    fact_passenger_summary
JOIN 
    dim_city ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name
ORDER BY 
    total_trips ASC
LIMIT 3);


-- 2. Average Fare per Trip by City

SELECT 
    dim_city.city_name,
    AVG(fact_trips.fare_amount) AS average_fare,
    AVG(fact_trips.distance_travelled_km) AS average_trip_distance
FROM 
    fact_trips
JOIN 
    dim_city ON fact_trips.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name;
-- 3. Average Ratings by City and Passenger Type
SELECT 
    dim_city.city_name,
    fact_trips.passenger_type,
    AVG(fact_trips.passenger_rating) AS avg_passenger_rating,
    AVG(fact_trips.driver_rating) AS avg_driver_rating
FROM 
    fact_trips
JOIN 
    dim_city ON fact_trips.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name, fact_trips.passenger_type;

-- 4. Peak and Low Demand Months by City
-- Peak Demand Month by City
SELECT 
    dim_city.city_name,
    DATE_FORMAT(fact_passenger_summary.month, '%Y-%m') AS month,
    SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
    fact_passenger_summary
JOIN 
    dim_city ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name, month
ORDER BY 
    total_trips DESC
LIMIT 1;

--  Low Demand Month by City

SELECT 
    dim_city.city_name,
    DATE_FORMAT(fact_passenger_summary.month, '%Y-%m') AS month,
    SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
    fact_passenger_summary
JOIN 
    dim_city ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name, month
ORDER BY 
    total_trips ASC
LIMIT 1;

-- alternative 
WITH RankedTrips AS (
    SELECT 
        dim_city.city_name,
        DATE_FORMAT(fact_passenger_summary.month, '%Y-%m') AS month,
        SUM(fact_passenger_summary.total_passengers) AS total_trips,
        ROW_NUMBER() OVER (PARTITION BY dim_city.city_name ORDER BY SUM(fact_passenger_summary.total_passengers) DESC) AS peak_rank,
        ROW_NUMBER() OVER (PARTITION BY dim_city.city_name ORDER BY SUM(fact_passenger_summary.total_passengers) ASC) AS low_rank
    FROM 
        fact_passenger_summary
    JOIN 
        dim_city ON fact_passenger_summary.city_id = dim_city.city_id
    GROUP BY 
        dim_city.city_name, month
)

SELECT 
    city_name,
    month,
    total_trips,
    'Peak Demand' AS demand_type  -- Label for peak demand
FROM 
    RankedTrips
WHERE 
    peak_rank = 1  -- Peak demand month (highest total trips)
    
UNION ALL

SELECT 
    city_name,
    month,
    total_trips,
    'Low Demand' AS demand_type  -- Label for low demand
FROM 
    RankedTrips
WHERE 
    low_rank = 1;  -- Low demand month (lowest total trips);


-- 5. Weekend vs. Weekday Trip Demand by City
SELECT 
    dim_city.city_name,
    dim_date.day_type,
    SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
    fact_passenger_summary
JOIN 
    dim_city ON fact_passenger_summary.city_id = dim_city.city_id
JOIN 
    dim_date ON fact_passenger_summary.month = dim_date.start_of_month
GROUP BY 
    dim_city.city_name, dim_date.day_type;

-- 6. Repeat Passenger Frequency and City Contribution Analysis

SELECT 
    dim_city.city_name,
    dim_repeat_trip_distribution.trip_count,
    SUM(dim_repeat_trip_distribution.repeat_passenger_count) AS repeat_passenger_count
FROM 
    dim_repeat_trip_distribution
JOIN 
    dim_city ON dim_repeat_trip_distribution.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name, dim_repeat_trip_distribution.trip_count
ORDER BY 
    SUM(dim_repeat_trip_distribution.repeat_passenger_count) DESC;

-- 7. Monthly Target Achievement Analysis for Key Metrics

SELECT 
    d.month_name AS Month_Name,  
    tgt.target_new_passengers AS Target_New_Passengers,  -- Target number of new passengers
    COUNT(CASE WHEN f.passenger_type = 'new' THEN 1 END) AS Actual_New_Passengers,  -- Count actual new passengers
    (COUNT(CASE WHEN f.passenger_type = 'new' THEN 1 END) / tgt.target_new_passengers) * 100 AS Achievement_Rate_New_Passengers,  -- Achievement rate for new passengers
    CASE 
        WHEN (COUNT(CASE WHEN f.passenger_type = 'new' THEN 1 END) / tgt.target_new_passengers) * 100 > 100 THEN 'Exceeded'  -- If achievement > 100%, mark as Exceeded
        ELSE 'Missed'  -- If achievement < 100%, mark as Missed
    END AS Status
FROM 
    targets_db.monthly_target_new_passengers tgt
JOIN 
    trips_db.fact_trips f ON tgt.city_id = f.city_id
JOIN 
    trips_db.dim_date d ON f.date = d.date
WHERE 
    d.date BETWEEN '2024-01-01' AND '2024-03-31'  -- Filtering for just Q1 2024 (reduce the date range temporarily)
GROUP BY 
    d.month_name, tgt.target_new_passengers
ORDER BY 
    FIELD(d.month_name, 'January', 'February', 'March')  -- Ordering by months for just Q1
LIMIT 100;  -- Limit to 100 results for testing



SELECT 
    c.city_name AS City,  -- Shortened city name column
    tgt.target_avg_passenger_rating AS Target_Rating,  -- Shortened target average passenger rating column
    AVG(f.passenger_rating) AS Actual_Rating,  -- Shortened actual average passenger rating column
    (AVG(f.passenger_rating) / tgt.target_avg_passenger_rating) * 100 AS Achievement_Rate,  -- Shortened achievement rate column
    CASE 
        WHEN (AVG(f.passenger_rating) / tgt.target_avg_passenger_rating) * 100 >= 100 THEN 'Exceeded'  -- If achievement rate is >= 100%, it's exceeded
        WHEN (AVG(f.passenger_rating) / tgt.target_avg_passenger_rating) * 100 = 100 THEN 'Achieved'   -- If achievement rate is exactly 100%, it's achieved
        ELSE 'Missed'  -- If achievement rate is < 100%, it's missed
    END AS Status  -- Shortened achievement status column
FROM 
    targets_db.city_target_passenger_rating tgt
JOIN 
    trips_db.fact_trips f ON tgt.city_id = f.city_id
JOIN 
    trips_db.dim_city c ON f.city_id = c.city_id  -- Joining with dim_city to get city names
WHERE 
    f.date BETWEEN '2024-01-01' AND '2024-06-30'  -- Filtering by the first half of 2024
GROUP BY 
    c.city_name, tgt.target_avg_passenger_rating
ORDER BY 
    Achievement_Rate DESC;  -- Ordering by Achievement Rate in descending order



-- 8. Highest and Lowest Repeat Passenger Rate (RPR%) by City and Month

-- Analyse the Repeat Passenger Rate (RPR%) for each city across the six-month period. Identify the top 2 and bottom 2 cities based on their RPR%

WITH RPR_Calculation AS (
    SELECT 
        fps.city_id,
        dc.city_name, 
        fps.month,  -- Using the existing 'month' column
        fps.repeat_passengers,
        fps.total_passengers,
        (fps.repeat_passengers / fps.total_passengers) * 100 AS RPR_percent
    FROM 
        fact_passenger_summary fps
    LEFT JOIN 
        trips_db.dim_city dc ON fps.city_id = dc.city_id
    WHERE 
        fps.total_passengers > 0
)
-- Identify Top 2 and Bottom 2 Cities by RPR%
SELECT 
    city_id, 
    city_name,
    CASE
        WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 1 THEN 'January'
        WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 2 THEN 'February'
        WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 3 THEN 'March'
        WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 4 THEN 'April'
        WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 5 THEN 'May'
        WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 6 THEN 'June'
        ELSE 'Other'
    END AS month_name,
    RPR_percent,
    CASE 
        WHEN RANK() OVER (ORDER BY RPR_percent DESC) <= 2 THEN 'Top'
        WHEN RANK() OVER (ORDER BY RPR_percent ASC) <= 2 THEN 'Bottom'
        ELSE NULL
    END AS RPR_Category
FROM 
    RPR_Calculation;
    
WITH RPR_Calculation AS (
    SELECT 
        fps.city_id,
        dc.city_name, 
        fps.month,  -- Using the existing 'month' column
        fps.repeat_passengers,
        fps.total_passengers,
        (fps.repeat_passengers / fps.total_passengers) * 100 AS RPR_percent
    FROM 
        fact_passenger_summary fps
    LEFT JOIN 
        trips_db.dim_city dc ON fps.city_id = dc.city_id
    WHERE 
        fps.total_passengers > 0
)
-- Pivot the data by month
SELECT 
    city_id, 
    city_name,
    -- Using conditional aggregation to create columns for each month
    MAX(CASE WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 1 THEN RPR_percent ELSE NULL END) AS Jan,
    MAX(CASE WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 2 THEN RPR_percent ELSE NULL END) AS Feb,
    MAX(CASE WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 3 THEN RPR_percent ELSE NULL END) AS Mar,
    MAX(CASE WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 4 THEN RPR_percent ELSE NULL END) AS Apr,
    MAX(CASE WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 5 THEN RPR_percent ELSE NULL END) AS May,
    MAX(CASE WHEN MONTH(STR_TO_DATE(month, '%Y-%m-%d')) = 6 THEN RPR_percent ELSE NULL END) AS Jun
FROM 
    RPR_Calculation
GROUP BY 
    city_id, city_name;
    
    
WITH RPR_Calculation AS (
    SELECT 
        fps.city_id,
        dc.city_name, 
        fps.month,  -- Using the existing 'month' column
        fps.repeat_passengers,
        fps.total_passengers,
        (fps.repeat_passengers / fps.total_passengers) * 100 AS RPR_percent
    FROM 
        fact_passenger_summary fps
    LEFT JOIN 
        trips_db.dim_city dc ON fps.city_id = dc.city_id
    WHERE 
        fps.total_passengers > 0
),
-- Calculate total RPR_percent per city
City_RPR AS (
    SELECT 
        city_id, 
        city_name,
        SUM(RPR_percent) AS total_RPR
    FROM 
        RPR_Calculation
    GROUP BY 
        city_id, city_name
)
-- Pivot the data by month and add total and rank columns
SELECT 
    r.city_id, 
    r.city_name,
    -- Using conditional aggregation to create columns for each month
    MAX(CASE WHEN MONTH(STR_TO_DATE(r.month, '%Y-%m-%d')) = 1 THEN r.RPR_percent ELSE NULL END) AS Jan,
    MAX(CASE WHEN MONTH(STR_TO_DATE(r.month, '%Y-%m-%d')) = 2 THEN r.RPR_percent ELSE NULL END) AS Feb,
    MAX(CASE WHEN MONTH(STR_TO_DATE(r.month, '%Y-%m-%d')) = 3 THEN r.RPR_percent ELSE NULL END) AS Mar,
    MAX(CASE WHEN MONTH(STR_TO_DATE(r.month, '%Y-%m-%d')) = 4 THEN r.RPR_percent ELSE NULL END) AS Apr,
    MAX(CASE WHEN MONTH(STR_TO_DATE(r.month, '%Y-%m-%d')) = 5 THEN r.RPR_percent ELSE NULL END) AS May,
    MAX(CASE WHEN MONTH(STR_TO_DATE(r.month, '%Y-%m-%d')) = 6 THEN r.RPR_percent ELSE NULL END) AS Jun,
    -- Total RPR for the city across all months
    c.total_RPR,
    -- Top 2 or Bottom 2 based on total RPR
    CASE 
        WHEN RANK() OVER (ORDER BY c.total_RPR DESC) <= 2 THEN 'Top'
        WHEN RANK() OVER (ORDER BY c.total_RPR ASC) <= 2 THEN 'Bottom'
        ELSE NULL
    END AS RPR_Category
FROM 
    RPR_Calculation r
JOIN 
    City_RPR c ON r.city_id = c.city_id
GROUP BY 
    r.city_id, r.city_name, c.total_RPR
ORDER BY 
    c.total_RPR DESC;

-- analyse the RPR% by month across all cities and identify the months with the highest and lowest repeat passenger rates

-- Calculate Repeat Passenger Rate (RPR%) by Month
WITH Monthly_RPR AS (
    SELECT 
        fps.month,
        DATE_FORMAT(fps.month, '%M') AS month_name, -- Adding month_name
        SUM(fps.repeat_passengers) AS total_repeat_passengers,
        SUM(fps.total_passengers) AS total_passengers,
        (SUM(fps.repeat_passengers) / SUM(fps.total_passengers)) * 100 AS RPR_percent
    FROM 
        fact_passenger_summary fps
    GROUP BY 
        fps.month
)
-- Identify Highest and Lowest Months
SELECT 
    month, 
    month_name, -- Display month_name
    RPR_percent,
    CASE 
        WHEN RANK() OVER (ORDER BY RPR_percent DESC) = 1 THEN 'Highest'
        WHEN RANK() OVER (ORDER BY RPR_percent ASC) = 1 THEN 'Lowest'
        ELSE NULL
    END AS RPR_Category
FROM 
    Monthly_RPR;
