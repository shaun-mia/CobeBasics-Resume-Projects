 
-- Business Request 4: Identify Cities with Highest and Lowest Total New Passengers

WITH city_ranking AS (
    SELECT 
        city_name, 
        SUM(new_passengers) AS total_new_passengers,  -- Replace 'new_passengers' with the actual column name
        DENSE_RANK() OVER (ORDER BY SUM(new_passengers) DESC) AS top_ranking,
        DENSE_RANK() OVER (ORDER BY SUM(new_passengers) ASC) AS bottom_ranking
    FROM fact_passenger_summary fps
    JOIN dim_city dc 
        ON fps.city_id = dc.city_id
    GROUP BY city_name
)

SELECT 
    city_name, 
    total_new_passengers, 
    CASE 
        WHEN top_ranking <= 3 THEN 'Top 3'
        WHEN bottom_ranking <= 3 THEN 'Bottom 3'
        ELSE NULL
    END AS city_category
FROM city_ranking
WHERE top_ranking <= 3 OR bottom_ranking <= 3
ORDER BY total_new_passengers DESC;