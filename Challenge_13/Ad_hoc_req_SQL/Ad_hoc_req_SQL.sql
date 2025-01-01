-- Craft SQL queries to address the specified business questions --

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

-- Business Request 2: Monthly City-Level Trips Target Performance Report
WITH cte1 AS (
    -- Calculate actual trips per city and month
    SELECT 
        ft.city_id, 
        dc.city_name, 
        dd.month_name, 
        COUNT(DISTINCT ft.trip_id) AS actual_trips
    FROM fact_trips ft
    JOIN dim_city dc 
        ON ft.city_id = dc.city_id
    JOIN dim_date dd 
        ON ft.date = dd.date
    GROUP BY ft.city_id, dc.city_name, dd.month_name
)

SELECT 
    cte1.city_name, 
    cte1.month_name, 
    cte1.actual_trips, 
    tt.total_target_trips,
    CASE
        WHEN cte1.actual_trips > tt.total_target_trips THEN 'Above Target'
        ELSE 'Below Target'
    END AS performance_status,
    CONCAT(ROUND((cte1.actual_trips - tt.total_target_trips) * 100.0 / tt.total_target_trips, 2), '%') AS pct_diff
FROM targets_db.monthly_target_trips tt
JOIN cte1 
    ON cte1.city_id = tt.city_id
    AND cte1.month_name = monthname(tt.month)
ORDER BY cte1.city_name, cte1.month_name;

-- Business Request 3: City-Level Repeat Passenger Trip Frequency Report (Percentage Distribution)

SELECT 
    c.city_name,
    -- Calculate the percentage of repeat passengers who took 2, 3, 4... up to 10 trips
    ROUND(SUM(CASE WHEN d.trip_count = '2-Trips' THEN d.repeat_passenger_count ELSE 0 END) / 
          SUM(d.repeat_passenger_count) * 100, 2) AS "2-Trips",
    ROUND(SUM(CASE WHEN d.trip_count = '3-Trips' THEN d.repeat_passenger_count ELSE 0 END) / 
          SUM(d.repeat_passenger_count) * 100, 2) AS "3-Trips",
    ROUND(SUM(CASE WHEN d.trip_count = '4-Trips' THEN d.repeat_passenger_count ELSE 0 END) / 
          SUM(d.repeat_passenger_count) * 100, 2) AS "4-Trips",
    ROUND(SUM(CASE WHEN d.trip_count = '5-Trips' THEN d.repeat_passenger_count ELSE 0 END) / 
          SUM(d.repeat_passenger_count) * 100, 2) AS "5-Trips",
    ROUND(SUM(CASE WHEN d.trip_count = '6-Trips' THEN d.repeat_passenger_count ELSE 0 END) / 
          SUM(d.repeat_passenger_count) * 100, 2) AS "6-Trips",
    ROUND(SUM(CASE WHEN d.trip_count = '7-Trips' THEN d.repeat_passenger_count ELSE 0 END) / 
          SUM(d.repeat_passenger_count) * 100, 2) AS "7-Trips",
    ROUND(SUM(CASE WHEN d.trip_count = '8-Trips' THEN d.repeat_passenger_count ELSE 0 END) / 
          SUM(d.repeat_passenger_count) * 100, 2) AS "8-Trips",
    ROUND(SUM(CASE WHEN d.trip_count = '9-Trips' THEN d.repeat_passenger_count ELSE 0 END) / 
          SUM(d.repeat_passenger_count) * 100, 2) AS "9-Trips",
    ROUND(SUM(CASE WHEN d.trip_count = '10-Trips' THEN d.repeat_passenger_count ELSE 0 END) / 
          SUM(d.repeat_passenger_count) * 100, 2) AS "10-Trips"
FROM
    dim_repeat_trip_distribution d
JOIN
    dim_city c ON d.city_id = c.city_id
WHERE
    d.trip_count IN ('2-Trips', '3-Trips', '4-Trips', '5-Trips', '6-Trips', '7-Trips', '8-Trips', '9-Trips', '10-Trips')
GROUP BY
    c.city_name
ORDER BY
    c.city_name;
    
-- Business Request 4: Identify Cities with Highest and Lowest Total New Passengers

WITH CityPassengerCounts AS (
    -- Calculate total new passengers for each city
    SELECT 
        dc.city_name, 
        SUM(fps.new_passengers) AS total_new_passengers
    FROM 
        trips_db.fact_passenger_summary fps
    JOIN 
        trips_db.dim_city dc 
    ON 
        fps.city_id = dc.city_id
    GROUP BY 
        dc.city_name
),
CityRanking AS (
    -- Rank cities based on total new passengers, both for top 3 and bottom 3
    SELECT 
        city_name, 
        total_new_passengers,
        DENSE_RANK() OVER(ORDER BY total_new_passengers DESC) AS top_ranking,
        DENSE_RANK() OVER(ORDER BY total_new_passengers ASC) AS bottom_ranking
    FROM 
        CityPassengerCounts
)
-- Select the top 3 and bottom 3 cities
SELECT 
    city_name, 
    total_new_passengers, 
    CASE 
        WHEN top_ranking <= 3 THEN 'Top 3'
        WHEN bottom_ranking <= 3 THEN 'Bottom 3'
        ELSE NULL
    END AS city_category
FROM 
    CityRanking
WHERE 
    top_ranking <= 3 OR bottom_ranking <= 3
ORDER BY 
    city_category DESC, total_new_passengers DESC;


-- Business Request 5: Identify Month with Highest Revenue for Each City
WITH RevenuePerCityMonth AS (
    -- Calculate total revenue for each city and month
    SELECT 
        dc.city_name,
        dd.month_name,
        SUM(ft.fare_amount) AS total_revenue
    FROM 
        trips_db.fact_trips ft
    JOIN 
        trips_db.dim_city dc 
    ON 
        ft.city_id = dc.city_id
    JOIN 
        trips_db.dim_date dd 
    ON 
        ft.date = dd.start_of_month
    GROUP BY 
        dc.city_name, dd.month_name
),
CityTotalRevenue AS (
    -- Calculate total revenue for each city
    SELECT 
        dc.city_name,
        SUM(ft.fare_amount) AS total_revenue
    FROM 
        trips_db.fact_trips ft
    JOIN 
        trips_db.dim_city dc 
    ON 
        ft.city_id = dc.city_id
    GROUP BY 
        dc.city_name
)
SELECT 
    r.city_name,
    r.month_name AS highest_revenue_month,
    r.total_revenue AS revenue,
    CONCAT(ROUND((r.total_revenue / tr.total_revenue) * 100, 2), '%') AS percentage_contribution
FROM 
    RevenuePerCityMonth r
JOIN 
    CityTotalRevenue tr
ON 
    r.city_name = tr.city_name
WHERE 
    r.total_revenue = (
        SELECT MAX(total_revenue)
        FROM RevenuePerCityMonth
        WHERE city_name = r.city_name
    )
ORDER BY 
    r.city_name;
    
-- Business Request 6: Repeat Passenger Rate Analysis

WITH monthly_repeat AS ( 
    SELECT 
        dc.city_name,
        dd.month_name,
        SUM(fps.total_passengers) AS total_passengers, 
        SUM(fps.repeat_passengers) AS repeat_passengers,
        CONCAT(ROUND((SUM(fps.repeat_passengers) * 100.0 / SUM(fps.total_passengers)), 2), '%') AS monthly_repeat_passenger_rate
    FROM 
        trips_db.fact_passenger_summary fps
    JOIN 
        trips_db.dim_city dc ON fps.city_id = dc.city_id
    JOIN 
        trips_db.dim_date dd ON fps.month = dd.start_of_month
    GROUP BY 
        dc.city_name, dd.month_name
),

city_repeat AS (
    SELECT 
        dc.city_name, 
        SUM(fps.total_passengers) AS total_passengers, 
        SUM(fps.repeat_passengers) AS repeat_passengers,
        CONCAT(ROUND((SUM(fps.repeat_passengers) * 100.0 / SUM(fps.total_passengers)), 2), '%') AS city_repeat_passenger_rate
    FROM 
        trips_db.fact_passenger_summary fps
    JOIN 
        trips_db.dim_city dc ON fps.city_id = dc.city_id
    GROUP BY 
        dc.city_name
)

SELECT 
    mr.city_name, 
    mr.month_name, 
    mr.total_passengers, 
    mr.repeat_passengers, 
    mr.monthly_repeat_passenger_rate, 
    cr.city_repeat_passenger_rate 
FROM 
    monthly_repeat mr
JOIN 
    city_repeat cr ON mr.city_name = cr.city_name
ORDER BY 
    mr.city_name, mr.month_name;
