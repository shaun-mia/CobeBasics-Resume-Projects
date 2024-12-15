
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