# GoodCabs Analysis
![Good cabs Performance analysis](https://github.com/user-attachments/assets/9166e9f9-206b-4e78-b4ac-211e3e447d82)


## Domain: Transportation and Mobility  
**Function**: Operation  
**Resume Project Challenge 13 by CodeBasics**

---

## Problem Statement

**Goodcabs**, a cab service company established two years ago, has gained a strong foothold in the Indian market by focusing on tier-2 cities. Unlike other cab service providers, Goodcabs is committed to supporting local drivers, helping them make a sustainable living in their hometowns while ensuring excellent service to passengers. With operations in ten tier-2 cities across India, Goodcabs has set ambitious performance targets for 2024 to drive growth and improve passenger satisfaction.

As part of this initiative, the Goodcabs management team aims to assess the company’s performance across key metrics, including trip volume, passenger satisfaction, repeat passenger rate, trip distribution, and the balance between new and repeat passengers.

However, the Chief of Operations, Bruce Haryali, wanted this immediately but the analytics manager Tony is engaged on another critical project. Tony decided to give this work to Peter Pandey who is the curious data analyst of Goodcabs. Since these insights will be directly reported to the Chief of Operations, Tony also provided some notes to Peter to support his work.

**Task:**

Imagine yourself as Peter Pandey and perform the following task to keep up the trust with your manager Tony Sharma.

1. Go through the metadata and analyse the datasets thoroughly. This is the most fundamental step.

2. Begin your analysis by referring to the ‘primary_and_secondary_questions.pdf’. You can use any tool of your choice (Python, SQL, PowerBI, Tableau, Excel) to analyse and answer these questions. More instructions are provided in this document.

3. Design a dashboard with your metrics and analysis. The dashboard should be self-explanatory and easy to understand.

4. Check “ad-hoc-requests.pdf” - this document includes important business questions, requiring SQL-based report generation.

5. You need to present this to the Chief of Operations - hence you need to create a convincing presentation with actionable insights.

**Additional Considerations:**

6. You can add more research questions and answer them in your presentation that suits your recommendations.

7. Be creative with your presentation, audio/video presentation will have more weightage.

**Note:**

1. We recommend you create a video presentation of ideally 15 minutes or less for the business stakeholders. Additionally, make a LinkedIn post that includes relevant links, your video presentation, and a reflection on your experience while working on this challenge.

2. You can check out this example presentation to gain some inspiration: Sample Presentation Link

3. Please see this detailed evaluation criteria which is provided in the document "evaluation criteria".

4. After completing your LinkedIn post, please submit the link in the input box provided.


Given the extensive information provided, here’s how you can structure your analysis and presentation:

---

### **Task 1: Understanding the Problem and Metadata**
1. **Domain Context**: The problem is set in the transportation and mobility sector focusing on operational metrics for Goodcabs, a cab service targeting Tier-2 cities in India.
2. **Objective**:
   - Analyze operational data to provide actionable insights.
   - Build a self-explanatory dashboard.
   - Prepare a compelling presentation for the Chief of Operations.
3. **Data Overview**:
   - **Trips Data**: Contains details on cities, dates, passengers, and trip specifics.
   - **Targets Data**: Monthly and city-specific targets for new passengers, trips, and ratings.

---

### **Task 2: Key Queries and Insights**
#### 1. **Top and Bottom Performing Cities**
- Top 3 Performing Cities by Total Trips
- SQL Query: 
```sql
SELECT 
 dim_city.city_name,
        
 SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
 fact_passenger_summary
JOIN 
 dim_city
    ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
 dim_city.city_name
ORDER BY 
 total_trips DESC
LIMIT 3;
```
**Output** 
| City_Name   | Total_Trips |
|-------------|-------------|
| Jaipur      | 55538       |
| Kochi       | 34042       | 
| Lucknow     | 25857       | 

- Bottom 3 Performing Cities by Total Trips
- SQL Query

```sql
SELECT 
 dim_city.city_name,
        
 SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
 fact_passenger_summary
JOIN 
 dim_city
    ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
 dim_city.city_name
ORDER BY 
 total_trips ASC
LIMIT 3;
```
**Output** 
| City_Name   | Total_Trips |
|-------------|-------------|
| Coimbatore  | 11065       |
| Mysore      | 13158       |
| Vadodara    | 14473       |
-  Alternative  SQL Query
```sql
(SELECT 
 city_name,
        
 SUM(fact_passenger_summary.total_passengers) AS total_trips,
        
 'Top 3' AS performance
FROM 
 fact_passenger_summary
JOIN 
 dim_city
    ON fact_passenger_summary.city_id = dim_city.city_id
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
 dim_city
    ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
 dim_city.city_name
ORDER BY 
 total_trips ASC
LIMIT 3);
```
**Output**  
| City_Name   | Total_Trips | Performance |
|-------------|-------------|-------------|
| Jaipur      | 55538       | Top 3       |
| Kochi       | 34042       | Top 3       |
| Lucknow     | 25857       | Top 3       |
| Coimbatore  | 11065       | Bottom 3    |
| Mysore      | 13158       | Bottom 3    |
| Vadodara    | 14473       | Bottom 3    |


### 2. Average Fare per Trip by City
```sql
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
```
**Output**  
| City_Name     | avg_Fare  | avg_Trip_Distance |
|---------------|-----------|-------------------|
| Chandigarh    | 283.6870  | 23.5187           |
| Coimbatore    | 166.9822  | 14.9792           |
| Indore        | 179.8386  | 16.5025           |
| Jaipur        | 483.9181  | 30.0231           |
| Kochi         | 335.2451  | 24.0655           |
| Lucknow       | 147.1804  | 12.5130           |
| Mysore        | 249.7072  | 16.4969           |
| Surat         | 117.2729  | 10.9972           |
| Vadodara      | 118.5662  | 11.5177           |
| Visakhapatnam | 282.6723  | 22.5539           |
---

### 3. Average Ratings by City and Passenger Type
```sql
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
```
**Output**  
| City_Name     | Passenger_Type | avg_Passenger_Rating | avg_Driver_Rating |
|---------------|----------------|----------------------|-------------------|
| Chandigarh    | new            | 8.4892               | 7.9921            |
| Chandigarh    | repeated       | 7.4938               | 7.4728            |
| Coimbatore    | new            | 8.4858               | 7.9906            |
| Coimbatore    | repeated       | 7.4755               | 7.4808            |
| Indore        | new            | 8.4858               | 7.9708            |
| Indore        | repeated       | 7.4740               | 7.4774            |
| Jaipur        | new            | 8.9850               | 8.9882            |
| Jaipur        | repeated       | 7.9910               | 8.9848            |
| Kochi         | new            | 8.9874               | 8.9853            |
| Kochi         | repeated       | 8.0037               | 8.9898            |
| Lucknow       | new            | 7.9774               | 6.9904            |
| Lucknow       | repeated       | 5.9857               | 6.4917            |
| Mysore        | new            | 8.9830               | 8.9829            |
| Mysore        | repeated       | 7.9785               | 8.9658            |
| Surat         | new            | 7.9842               | 6.9949            |
| Surat         | repeated       | 5.9955               | 6.4794            |
| Vadodara      | new            | 7.9793               | 7.0041            |
| Vadodara      | repeated       | 5.9786               | 6.4811            |
| Visakhapatnam | new            | 8.9762               | 8.9800            |
| Visakhapatnam | repeated       | 7.9896               | 8.9927            |

---

### 4. Peak and Low Demand Months by City

**Peak Demand Month by City**:
```sql
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
```
**Output**  
| City         | Date       | Total_trips  |
|--------------|------------|---------|
| Jaipur       | 2024-02    | 12450   |

**Low Demand Month by City**:
```sql
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
```
**Output**  
| City        | Date       | Total_trips |
|-------------|------------|--------|
| Coimbatore  | 2024-05    | 1543   |
**Alternative (Using ROW_NUMBER for Peak and Low)**:
```sql
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
    'Peak Demand' AS demand_type
FROM 
    RankedTrips
WHERE 
    peak_rank = 1

UNION ALL

SELECT 
    city_name,
    month,
    total_trips,
    'Low Demand' AS demand_type
FROM 
    RankedTrips
WHERE 
    low_rank = 1;
```
**Output**  
| City          | Date       | Demand  | Type        |
|---------------|------------|---------|-------------|
| Jaipur        | 2024-02    | 12450   | Peak Demand |
| Kochi         | 2024-04    | 6515    | Peak Demand |
| Lucknow       | 2024-02    | 5188    | Peak Demand |
|---------------|------------|---------|-------------|
| Chandigarh    | 2024-04    | 3285    | Low Demand  |
| Coimbatore    | 2024-05    | 1543    | Low Demand  |
| Indore        | 2024-06    | 3152    | Low Demand  |

---

### 5. Weekend vs. Weekday Trip Demand by City
```sql
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
```
**Output**  
| City           | Day Type   | Count    |
|----------------|------------|----------|
| Lucknow        | Weekday    | 559872   |
| Coimbatore     | Weekday    | 239973   |
| Jaipur         | Weekday    | 1205236  |
| Indore         | Weekday    | 479087   |
| Kochi          | Weekday    | 741101   |
|----------------|------------|----------|
| Visakhapatnam  | Weekend    | 154430   |

---

### 6. Repeat Passenger Frequency and City Contribution Analysis
```sql
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
```
**Output**  
| City           | Trip Count | Repeat Passenger Count |
|----------------|------------|------------------------|
| Jaipur         | 2-Trips    | 4855                   |
| Kochi          | 2-Trips    | 3635                   |
| Visakhapatnam  | 2-Trips    | 2618                   |
| Indore         | 2-Trips    | 2478                   |
| Jaipur         | 3-Trips    | 2007                   |
|----------------|------------|------------------------|
| Mysore         | 10-Trips   | 7                      |
---

### 7. Monthly Target Achievement Analysis for Key Metrics


- Passenger Rating Achievement Analysis 
```sql
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

```
**Output**  
| **City**        | **Target Avg Passenger Rating** | **Actual Avg Passenger Rating** | **Achievement Rate** | **Status** |
|-----------------|----------------------------------|----------------------------------|-----------------------|------------|
| Jaipur          | 8.25                             | 8.5838                           | 104.05%               | Exceeded   |
| Mysore          | 8.50                             | 8.7011                           | 102.37%               | Exceeded   |
| Kochi           | 8.50                             | 8.5162                           | 100.19%               | Exceeded   |
| Chandigarh      | 8.00                             | 7.9766                           | 99.71%                | Missed     |
| Visakhapatnam   | 8.50                             | 8.4329                           | 99.21%                | Missed     |
| Indore          | 8.00                             | 7.8282                           | 97.85%                | Missed     |
| Coimbatore      | 8.25                             | 7.8831                           | 95.55%                | Missed     |
| Surat           | 7.00                             | 6.4171                           | 91.67%                | Missed     |
| Lucknow         | 7.25                             | 6.4894                           | 89.51%                | Missed     |
| Vadodara        | 7.50                             | 6.6113                           | 88.15%                | Missed     |

---

### 8. Highest and Lowest Repeat Passenger Rate (RPR%) by City and Month
```sql
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

```
**Output**  

| city_id | city_name     | Jan    | Feb    | Mar    | Apr    | May    | Jun    | total_RPR | RPR_Category |
|---------|---------------|--------|--------|--------|--------|--------|--------|-----------|--------------|
| GJ01    | Surat         | 32.7434| 36.8096| 43.4302| 45.6983| 49.9223| 49.1749| 257.7787  | Top          |
| UP01    | Lucknow       | 29.2279| 31.9776| 33.9260| 39.2960| 47.6627| 46.7009| 228.7911  | Top          |
| MP01    | Indore        | 26.6512| 27.7066| 28.4633| 35.5184| 43.5255| 35.8820| 197.7470  |              |
| GJ02    | Vadodara      | 20.6608| 22.1335| 30.0952| 34.4938| 38.4752| 38.9043| 184.7628  |              |
| AP01    | Visakhapatnam | 20.5501| 24.9211| 29.8416| 34.9665| 32.9066| 29.6817| 172.8676  |              |
| TN01    | Coimbatore    | 17.7055| 17.3608| 21.7303| 27.8746| 32.6636| 24.6929| 142.0277  |              |
| KL01    | Kochi         | 14.0459| 18.7081| 21.6964| 24.1903| 29.7814| 25.8374| 134.2595  |              |
| CH01    | Chandigarh    | 15.5172| 17.2080| 21.2683| 24.0183| 26.1963| 26.2966| 130.5047  |              |
| RJ01    | Jaipur        | 12.0051| 13.3414| 19.8768| 22.0978| 25.6761| 16.9781| 109.9753  | Bottom       |
| KA01    | Mysore        | 8.0789 | 7.9913 | 9.4804 | 11.3900| 15.3744| 14.9342| 67.2492   | Bottom       |


```sql
-- Calculate Repeat Passenger Rate (RPR%) by Month
WITH Monthly_RPR AS (
SELECT 
 fps.month,
        
 DATE_FORMAT(fps.month,
        '%M') AS month_name,
        -- Adding month_name
 SUM(fps.repeat_passengers) AS total_repeat_passengers,
        
 SUM(fps.total_passengers) AS total_passengers,
        
 (SUM(fps.repeat_passengers) / SUM(fps.total_passengers)) * 100 AS RPR_percent

    FROM 
 fact_passenger_summary fps

    GROUP BY  
 fps.month
)
-- Identify Highest
        AND Lowest Months
SELECT 
 month,
        
 month_name,
        -- Display month_name
 RPR_percent,
        
 
    CASE 

    WHEN RANK()
    OVER (ORDER BY RPR_percent DESC) = 1 THEN
    'Highest'

    WHEN RANK()
    OVER (ORDER BY RPR_percent ASC) = 1 THEN
    'Lowest'

    ELSE NULL

    END AS RPR_Category
FROM 
 Monthly_RPR;
```
**Output**  
| month         | month_name   | RPR_percent | RPR_Category |
|---------------|--------------|-------------|--------------|
| 2024-01-01    | January      | 18.6761     | Lowest       |
| 2024-02-01    | February     | 20.8271     |              |
| 2024-03-01    | March        | 25.5665     |              |
| 2024-04-01    | April        | 29.2642     |              |
| 2024-06-01    | June         | 29.7575     |              |
| 2024-05-01    | May          | 33.4727     | Highest      |
---

### **Task 3: Dashboard Design**
#### Tools: Power BI
- **Key Visuals**:
   - **Bar Charts** for top/bottom cities.
   - **Maps** to show geographical performance.
   - **Line Charts** for seasonal demand trends.
   - **Scatter Plots** for fare vs. trip distance.
   - **KPI Cards** for metrics like average ratings.
- **Interactivity**:
   - Filters for city, month, and passenger type.
   - Dynamic slicers for targets vs. actuals.

# Good Cabs Performance Analysis Dashboard

This is a comprehensive performance analysis dashboard for a ride-hailing business, which helps in evaluating various performance metrics, including trip data, ratings, city-wise analysis, passenger behavior, monthly growth, and comparisons between target and actual performance.

## Table of Contents
- [Project Overview](#project-overview)
- [Pages Overview](#pages-overview)
  - [Home](#home)
  - [Overview](#overview)
  - [City](#city)
  - [Comparison](#comparison)
  - [Behavior](#behavior)
  - [Monthly](#monthly)
- [KPIs and Metrics](#kpis-and-metrics)
- [Visuals](#visuals)
- [Footer](#footer)

## Project Overview

The **Good Cabs Performance Analysis Dashboard** is built using Power BI to track and analyze various key performance indicators (KPIs) related to cabs and their performance. The dashboard provides insights into trip data, performance by city, comparison of target versus actual performance, passenger behavior, and monthly trends.

## Pages Overview

The dashboard consists of six main pages:

### 1. **Home**
   - **Subtitle**: Welcome to the Good Cabs Performance Dashboard
   - **Description**: The Home page provides a summary of the entire dashboard with key metrics at a glance. This page includes navigation links to all other pages, ensuring easy access to different insights.

---

## **Page 1: Overview Dashboard**
### **Title**: *Company Performance Overview*  
**Subtitle**: *Summary of Key Metrics and Insights*
(Use these keywords to create navigation buttons to other pages.)
---

### **KPIs**:
1. **Total Trips** (Aggregated across all cities and months).  
   **DAX**:  
   ```DAX
   Total Trips = SUM(fact_trips[trip_id])
   ```
2. **Total Passengers** (New + Repeat).  
   **DAX**:  
   ```DAX
   Total Passengers = SUM(fact_passenger_summary[total_passengers])
   ```
3. **Average Passenger Rating**.  
   **DAX**:  
   ```DAX
   Avg Passenger Rating = AVERAGE(fact_trips[passenger_rating])
   ```
4. **Revenue Generated** (if a revenue column exists; calculated from `fare_amount`).  
   **DAX**:  
   ```DAX
   Total Revenue = SUM(fact_trips[fare_amount])
   ```

---

### **Visuals**:
- **Card Visuals** for KPIs (Total Trips, Total Passengers, Average Passenger Rating, Total Revenue).  
  - Use contrasting colors for easy readability (e.g., green for positive growth KPIs, red for negative trends).
- **Clustered Bar Chart**: *Trips by City*.  
  **Axis**: City (dim_city[city_name])  
  **Values**: Count of Trips (fact_trips[trip_id])
- **Pie Chart**: *New vs. Repeat Passengers*.  
  **Values**: New Passengers (fact_passenger_summary[new_passengers])  
  Repeat Passengers (fact_passenger_summary[repeat_passengers])

---

### **Steps**:
1. Load data from `trips_db` and `targets_db` into Power BI.
2. Create relationships between tables:
   - `dim_city` → `city_id`
   - `dim_date` → `date`
   - `fact_passenger_summary` → `city_id` and `month`
3. Use slicers for **City** and **Month** filtering.

---

## **Page 2: City-wise Analysis**  
### **Title**: *City Performance Overview*  
**Subtitle**: *Detailed Insights Across All Cities*  

---

### **KPIs**:
1. **Total Trips by City**.  
   **DAX**:  
   ```DAX
   Trips By City = COUNT(fact_trips[trip_id])
   ```
2. **Average Rating by City**.  
   **DAX**:  
   ```DAX
   Avg Rating By City = CALCULATE(AVERAGE(fact_trips[passenger_rating]), ALLEXCEPT(dim_city, dim_city[city_name]))
   ```
3. **Total New Passengers by City**.  
   **DAX**:  
   ```DAX
   New Passengers By City = SUM(fact_passenger_summary[new_passengers])
   ```

---

### **Visuals**:
- **Heatmap**: City-wise Trip Volume.  
  - Use City on the rows and Months on the columns with a color gradient based on the trip count.
- **Line Chart**: Trends of Repeat Passengers Over Months.  
  **Axis**: Month  
  **Values**: Repeat Passengers (fact_passenger_summary[repeat_passengers])
- **Stacked Column Chart**: New vs. Repeat Passengers by City.  
  **Axis**: City  
  **Values**: New Passengers, Repeat Passengers

---

## **Page 3: Target vs. Actuals**  
### **Title**: *Performance vs. Targets*  
**Subtitle**: *Achievement Metrics Across KPIs*

---

### **KPIs**:
1. **Target Achievement % for Trips**.  
   **DAX**:  
   ```DAX
   Trip Achievement % = 
   DIVIDE(SUM(fact_trips[trip_id]), SUM(monthly_target_trips[total_target_trips])) * 100
   ```
2. **Target Achievement % for New Passengers**.  
   **DAX**:  
   ```DAX
   New Passenger Achievement % = 
   DIVIDE(SUM(fact_passenger_summary[new_passengers]), SUM(monthly_target_new_passengers[target_new_passengers])) * 100
   ```
3. **Gap in Average Ratings**.  
   **DAX**:  
   ```DAX
   Rating Gap = 
   AVERAGE(city_target_passenger_rating[target_avg_passenger_rating]) - 
   AVERAGE(fact_trips[passenger_rating])
   ```
---

### **Visuals**:
- **Bar and Line Combo Chart**: *Target vs. Actual Trips*.  
  **Bars**: Actual Trips (fact_trips[trip_id])  
  **Lines**: Target Trips (monthly_target_trips[total_target_trips])
- **Gauge Chart**: *Achievement Percentage for New Passengers*.  
- **Clustered Bar Chart**: Ratings Gap by City.  

---

## **Page 4: Repeat Passenger Behavior**  
### **Title**: *Repeat Passenger Insights*  
**Subtitle**: *Behavior Patterns Across Cities and Months*  

---

### **KPIs**:
1. **Top Cities with High Repeat Rates**.  
   **DAX**:  
   ```DAX
   Repeat Rate = DIVIDE(SUM(fact_passenger_summary[repeat_passengers]), SUM(fact_passenger_summary[total_passengers])) * 100
   ```
2. **Repeat Passenger Trip Frequency Distribution** (1-10 trips).  

---

### **Visuals**:
- **Histogram**: Repeat Passenger Trip Distribution.  
  **Bins**: Trip Frequency (dim_repeat_trip_distribution[trip_count])  
- **Bubble Chart**: Cities with High Repeat Rates vs. Total Trips.  

---

## **Page 5: Monthly Trends**  
### **Title**: *Monthly Trends Overview*  
**Subtitle**: *Passenger and Trip Trends by Month*   
---

### **KPIs**:
1. **Monthly Growth in Trips**.  
   **DAX**:  
   ```DAX
   Monthly Trip Growth = 
   DIVIDE(SUM(fact_trips[trip_id]) - 
   CALCULATE(SUM(fact_trips[trip_id]), PREVIOUSMONTH(dim_date[date])), 
   CALCULATE(SUM(fact_trips[trip_id]), PREVIOUSMONTH(dim_date[date]))) * 100
   ```

---

### **Visuals**:
- **Line Chart**: Trip Volume by Month.  
- **Clustered Bar Chart**: Total Passengers by Month.  
---


### **Task 4:ad-hoc-requests**

### **Business Request 1: City-Level Fare and Trip Summary Report**

```sql
-- City-Level Fare and Trip Summary Report
USE trips_db;

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
```
**Output** 

| city_name      | total_trips | avg_fare_per_km | avg_fare_per_trip | pct_cont_total_trips |
|----------------|-------------|-----------------|-------------------|----------------------|
| Jaipur         | 76888       | 16.1            | 483.9             | 18.1                 |
| Lucknow        | 64299       | 11.8            | 147.2             | 15.1                 |
| Surat          | 54843       | 10.7            | 117.3             | 12.9                 |
| Kochi          | 50702       | 13.9            | 335.2             | 11.9                 |
| Indore         | 42456       | 10.9            | 179.8             | 10                   |
| Chandigarh     | 38981       | 12.1            | 283.7             | 9.2                  |
| Vadodara       | 32026       | 10.3            | 118.6             | 7.5                  |
| Visakhapatnam  | 28366       | 12.5            | 282.7             | 6.7                  |
| Coimbatore     | 21104       | 11.1            | 167               | 5                    |
| Mysore         | 16238       | 15.1            | 249.7             | 3.8                  |

---

### **Business Request 2: Monthly City-Level Trips Target Performance Report**

```sql
-- Monthly City-Level Trips Target Performance Report
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
```
**Output** 
| city_name    | month_name | actual_trips | total_target_trips | performance_status | pct_diff |
|--------------|------------|--------------|--------------------|--------------------|----------|
| Chandigarh   | April      | 5566         | 6000               | Below Target       | -7.23%   |
| Chandigarh   | February   | 7387         | 7000               | Above Target       | 5.53%    |
| Chandigarh   | January    | 6810         | 7000               | Below Target       | -2.71%   |
| Chandigarh   | June       | 6029         | 6000               | Above Target       | 0.48%    |
| Chandigarh   | March      | 6569         | 7000               | Below Target       | -6.16%   |
| Chandigarh   | May        | 6620         | 6000               | Above Target       | 10.33%   |
| Coimbatore   | April      | 3661         | 3500               | Above Target       | 4.60%    |
| Coimbatore   | February   | 3404         | 3500               | Below Target       | -2.74%   |
| Coimbatore   | January    | 3651         | 3500               | Above Target       | 4.31%    |
|--------------|------------|--------------|--------------------|--------------------|----------|
| Visakhapatnam   | March   | 4877         | 4500               |Above Target     | 8.38%  |
| Visakhapatnam   | May    | 4812         | 5000               | Below Target       | -3.76%   |

---

### **Business Request 3: City-Level Repeat Passenger Trip Frequency Report (Percentage Distribution)**

```sql
-- City-Level Repeat Passenger Trip Frequency Report
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
```
**Output** 

| city_name      | 2-Trips | 3-Trips | 4-Trips | 5-Trips | 6-Trips | 7-Trips | 8-Trips | 9-Trips | 10-Trips |
|----------------|---------|---------|---------|---------|---------|---------|---------|---------|----------|
| Chandigarh     | 32.31   | 19.25   | 15.74   | 12.21   | 7.42    | 5.48    | 3.47    | 2.33    | 1.79     |
| Coimbatore     | 11.21   | 14.82   | 15.56   | 20.62   | 17.64   | 10.47   | 6.15    | 2.31    | 1.22     |
| Indore         | 34.34   | 22.69   | 13.4    | 10.34   | 6.85    | 5.24    | 3.26    | 2.38    | 1.51     |
| Jaipur         | 50.14   | 20.73   | 12.12   | 6.29    | 4.13    | 2.52    | 1.9     | 1.2     | 0.97     |
| Kochi          | 47.67   | 24.35   | 11.81   | 6.48    | 3.91    | 2.11    | 1.65    | 1.21    | 0.81     |
| Lucknow        | 9.66    | 14.77   | 16.2    | 18.42   | 20.18   | 11.33   | 6.43    | 1.91    | 1.1      |
| Mysore         | 48.75   | 24.44   | 12.73   | 5.82    | 4.06    | 1.76    | 1.42    | 0.54    | 0.47     |
| Surat          | 9.76    | 14.26   | 16.55   | 19.75   | 18.45   | 11.89   | 6.24    | 1.74    | 1.35     |
| Vadodara       | 9.87    | 14.17   | 16.52   | 18.06   | 19.08   | 12.86   | 5.78    | 2.05    | 1.61     |
| Visakhapatnam  | 51.25   | 24.96   | 9.98    | 5.44    | 3.19    | 1.98    | 1.39    | 0.88    | 0.92     |
---

### **Business Request 4: Identify Cities with Highest and Lowest Total New Passengers**

```sql
-- Identify Cities with Highest and Lowest Total New Passengers
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
```
**Output** 

| city_name      | total_new_passengers | city_category |
|----------------|----------------------|---------------|
| Jaipur         | 45856                | Top 3         |
| Kochi          | 26416                | Top 3         |
| Chandigarh     | 18908                | Top 3         |
| Surat          | 11626                | Bottom 3      |
| Vadodara       | 10127                | Bottom 3      |
| Coimbatore     | 8514                 | Bottom 3      |
---

### **Business Request 5: Identify Month with Highest Revenue for Each City**

```sql
-- Identify Month with Highest Revenue for Each City
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
```
**Output** 
| city_name      | highest_revenue_month | revenue  | percentage_contribution |
|----------------|-----------------------|----------|-------------------------|
| Chandigarh     | June                  | 3107520  | 28.10%                  |
| Coimbatore     | June                  | 641250   | 18.20%                  |
| Indore         | June                  | 2004510  | 26.25%                  |
| Jaipur         | June                  | 8940510  | 24.03%                  |
| Kochi          | June                  | 3837000  | 22.57%                  |
| Lucknow        | February              | 1735070  | 18.33%                  |
| Mysore         | June                  | 1452150  | 35.81%                  |
| Surat          | May                   | 1148364  | 17.86%                  |
| Vadodara       | June                  | 796320   | 20.97%                  |
| Visakhapatnam  | June                  | 2311500  | 28.83%                  |

---

### **Business Request 6: Repeat Passenger Rate Analysis**

```sql
-- Repeat Passenger Rate Analysis
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
    mr

.city_name, 
    mr.month_name, 
    mr.monthly_repeat_passenger_rate,
    cr.city_repeat_passenger_rate
FROM 
    monthly_repeat mr
JOIN 
    city_repeat cr ON mr.city_name = cr.city_name
ORDER BY 
    mr.city_name, mr.month_name;
```
**Output** 
| city_name      | month_name | total_passengers | repeat_passengers | monthly_repeat_passenger_rate | city_repeat_passenger_rate |
|----------------|------------|------------------|-------------------|-------------------------------|----------------------------|
| Chandigarh     | April      | 98550            | 23670             | 24.02%                        | 21.14%                     |
| Chandigarh     | February  | 143753           | 24737             | 17.21%                        | 21.14%                     |
| Chandigarh     | January   | 143840           | 22320             | 15.52%                        | 21.14%                     |
| Chandigarh     | June      | 98910            | 26010             | 26.30%                        | 21.14%                     |
| Chandigarh     | March     | 127100           | 27032             | 21.27%                        | 21.14%                     |
| Chandigarh     | May       | 114669           | 30039             | 26.20%                        | 21.14%                     |
| Coimbatore     | April      | 51660            | 14400             | 27.87%                        | 23.05%                     |
| Coimbatore     | February  | 57797            | 10034             | 17.36%                        | 23.05%                     |
| Coimbatore     | January   | 68634            | 12152             | 17.71%                        | 23.05%                     |
|----------------|------------|------------------|-------------------|-------------------------------|----------------------------|
| Visakhapatnam     | May   | 89590            | 29481	             |32.91%                       | 28.61%                     |		

---
   
### **Task 5: Presentation**
1. **Title Slide**: “Goodcabs Operational Analysis – 2024 Strategy Insights.”
2. **Introduction**: Brief on the company, data, and objectives.
3. **Methodology**: Overview of tools and analysis process.
4. **Key Findings**:
   - Performance highlights by city.
   - Pricing and trip efficiency insights.
   - Passenger satisfaction metrics.
   - Seasonal demand trends.
5. **Recommendations**:
   - Boost marketing in underperforming cities.
   - Revise fare structures based on efficiency.
   - Target specific months for promotional offers.
6. **Dashboard Demo**: Show live interactivity.
7. **Conclusion**: Summarize insights and next steps.

---
### **Connect with Me**  
[![LinkedIn](https://img.shields.io/badge/-LinkedIn-blue?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/posts/shaun-mia_powerbi-dataanalytics-sql-activity-7280308051507601408-L0UC?utm_source=share&utm_medium=member_desktop)  
[![YouTube](https://img.shields.io/badge/-YouTube-red?style=flat&logo=youtube&logoColor=white)]([YOUR_YOUTUBE_LINK](https://youtu.be/GbiYsTOGn78?si=55nj9bgU4peBhzC9))

## **Structure**  

- 📂 **Ad_hoc_req_SQL**  
- 📂 **Dashboard**  
- 📂 **Using Icon**  
- 📂 **primary&secondary_questions_Analysis_Using_SQL**  
- 📄 **Additional Documentations.pdf**  
- 📄 **Good Cabs Performance Analysis.pptx**  
- 📄 **README.md**



# Author Information

👤 **Shaun Mia**  
📍 Mirpur-1, Dhaka, Bangladesh  

### Contact Information:
- ✉️ **Email**: [shaunmia.cse@gmail.com](mailto:shaunmia.cse@gmail.com)
- 💻 **GitHub**: [https://github.com/shaun-mia](https://github.com/shaun-mia)
- 🔗 **LinkedIn**: [https://www.linkedin.com/in/shaun-mia](https://www.linkedin.com/in/shaun-mia)
- 🌐 **Portfolio**: [https://shaun-mia.github.io/](https://shaun-mia.github.io/)
---
