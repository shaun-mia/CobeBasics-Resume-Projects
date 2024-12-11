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
    low_rank = 1;  -- Low demand month (lowest total trips)


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
    dim_city.city_name,
    dim_repeat_trip_distribution.trip_count,
    SUM(dim_repeat_trip_distribution.repeat_passenger_count) AS repeat_passenger_count
FROM 
    trips_db.dim_repeat_trip_distribution
JOIN 
    trips_db.dim_city ON trips_db.dim_repeat_trip_distribution.city_id = trips_db.dim_city.city_id
GROUP BY 
    dim_city.city_name, dim_repeat_trip_distribution.trip_count
ORDER BY 
    repeat_passenger_count DESC
LIMIT 1000;
-- 8. Highest and Lowest Repeat Passenger Rate (RPR%) by City and Month
SELECT 
    dim_city.city_name,
    dim_repeat_trip_distribution.trip_count,
    SUM(dim_repeat_trip_distribution.repeat_passenger_count) AS repeat_passenger_count
FROM 
    trips_db.dim_repeat_trip_distribution
JOIN 
    trips_db.dim_city ON trips_db.dim_repeat_trip_distribution.city_id = trips_db.dim_city.city_id
GROUP BY 
    dim_city.city_name, dim_repeat_trip_distribution.trip_count
ORDER BY 
    repeat_passenger_count ASC
LIMIT 1000;
