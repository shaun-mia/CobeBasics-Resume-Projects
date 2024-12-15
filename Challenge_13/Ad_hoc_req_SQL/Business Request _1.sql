-- Business Request 1: City-Level Fare and Trip Summary Report

use trips_db;
SELECT 
    dc.city_name, 
    COUNT(ft.trip_id) AS total_trips, 
    ROUND(SUM(ft.fare_amount) / SUM(ft.distance_travelled_km), 1) AS avg_fare_per_km,
    ROUND(SUM(ft.fare_amount) / COUNT(ft.trip_id), 1) AS avg_fare_per_trip,
    ROUND(COUNT(ft.trip_id) * 100.0 / (SELECT COUNT(trip_id) FROM fact_trips), 1) AS pct_cont_total_trips
FROM 
    fact_trips ft
JOIN 
    dim_city dc 
    ON dc.city_id = ft.city_id
GROUP BY 
    dc.city_name
ORDER BY 
    pct_cont_total_trips DESC;