
# 🚴 Cyclistic Capstone Project

A case study for the Google Data Analytics Certificate. The project analyzes user behavior in Chicago's city bike program to help convert casual riders into annual members.

## 📊 Project Overview
- **Business Task:** Design marketing strategies to convert casual riders into members.
- **Tools Used:** SQL (BigQuery), Tableau

## 📂 Table of Contents
1. [Data Source](#data-source)
2. [Business Task](#business-task)
3. [Data Cleaning](#data-cleaning)
4. [SQL Queries](#sql-queries)
5. [Visualizations](#visualizations)
6. [Analysis](#analysis)
7. [Recommendations](#recommendations)

---

## 📁 Data Source
The dataset is provided by the Chicago city bike program.  
🔗 [Dataset Link](https://divvy-tripdata.s3.amazonaws.com/index.html)

---

## 🏢 Business Task
- Understand differences between casual riders and members.
- Explore why casual riders would buy a membership.

---

## 🧹 Data Cleaning
- Downloaded 12 CSV files (one for each month of 2021).
- Uploaded the data to BigQuery for analysis.
- Addressed missing location data using latitude and longitude.

➡️ [SQL Code to Replace Null Values](https://github.com/CarlosCandamil/Cyclistic/blob/main/Loco.sql)

---

## 🖥️ SQL Queries
### Query 1: Metrics Summary
```sql
SELECT 
  member_casual,
  CASE WHEN rideable_type IN ("classic_bike", "docked_bike") THEN "classic_dock" ELSE "electric" END AS type_of_bike,
  COUNT(ride_id) AS number_rides_pertype,
  ROUND(AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS avg_trip_dur_min,
  ROUND(STDDEV(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS std_trip_dur,
  ROUND(AVG(ST_DISTANCE(ST_GEOGPOINT(start_lng, start_lat), ST_GEOGPOINT(end_lng, end_lat)) / 1000), 2) AS avg_trip_distance_km
FROM 
  `Cyclistic.2021_*`
GROUP BY 
  type_of_bike, member_casual
ORDER BY 
  member_casual;
```
🔗 [View Full Query](https://github.com/CarlosCandamil/Cyclistic/blob/main/Metrics.sql)

---

## 📊 Visualizations
### Dashboard 1: Metrics Summary
![Metrics Summary](https://github.com/CarlosCandamil/Cyclistic/blob/main/Dashboard%201.png)

### Dashboard 2: Chicago Map Heatmap
![Chicago Map](https://github.com/CarlosCandamil/Cyclistic/blob/main/Dashboard%202.png)

---

## 🔍 Analysis
- **Members** take more rides than casual users (3.066M vs. 2.529M).
- **Casual Riders** take longer trips, especially with classic bikes.

---

## 📋 Recommendations
1. **Survey Users** to understand preferences for bike types.
2. **Target Marketing Campaigns** at stations with more casual riders.
