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
    mr.city_name, 
    FIELD(mr.month_name, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');