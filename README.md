# Cyclistic /Capstone Project 

This is a Case Study (Fictional) for the Google data analytics certificate, dataset is from the Chicago city bike program   

## Business Task 
- Design marketing strategies aimed at converting casual riders into annual members.
- Understand how annual members and casual riders differ.
- Why casual riders would buy a membership.

## Data 
Dataset is from the Chicago city bike program [Dataset](https://divvy-tripdata.s3.amazonaws.com/index.html) 

## Data Cleaning and Manipulation
- Downloaded 12 .csv files "202101-divvy-tripdata.zip" to "202112-divvy-tripdata.zip"
- Split files "202106-divvy-tripdata.zip" to "202110-divvy-tripdata.zip" into two .csv files each to be able to upload to *BigQuery* (csv size limit 100MB)
- Created dataset Cyclistic on *BibQuery* and uploaded all csv files as tables.

### Queries
1. (Query 1) to get **Average** and **Standard Deviation** on trips distance and duration aggregated by User type (mamber or Casual) and bike type (electric or docked/classic). 
```sql
SELECT 
member_casual,
CASE WHEN rideable_type IN ("classic_bike", "docked_bike") then "classic_dock" ELSE "electric" end as type_of_bike,

COUNT(ride_id) as number_rides_pertype,

ROUND(AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)),2) as avg_trip_dur_min,
ROUND(STDDEV(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)),2) AS std_trip_dur,

ROUND(AVG(ST_DISTANCE( ST_GEOGPOINT(start_lng, start_lat),ST_GEOGPOINT(end_lng, end_lat))/1000),2) as avg_trip_distance_km,
ROUND(STDDEV(ST_DISTANCE( ST_GEOGPOINT(start_lng, start_lat),ST_GEOGPOINT(end_lng, end_lat))/1000),2) AS std_distance

FROM 
`Cyclistic.2021_*`

group by  type_of_bike, member_casual
order by member_casual;
```
Used *Tableau* to visualize the data **Dashboard 1**
[Metrics](https://github.com/CarlosCandamil/Cyclistic/blob/main/Dashboard%201.png)

2. (Query 2) created to get trip duration ranges 

```sql
 WITH trip_time_table AS
        (SELECT
        member_casual,
        TIMESTAMP_DIFF(ended_at, started_at, MINUTE) as trip_time 
        FROM 
        `Cyclistic.2021_*`)
SELECT 
member_casual,
        sum(case when trip_time <= 40 then 1 else 0 end) as under_40min,
       sum(case when trip_time > 40 and trip_time <= 120 then 1 else 0 end) as f40min_2H,
       sum(case when trip_time > 120 and trip_time <= 240 then 1 else 0 end) as f2H_4H,
       sum(case when trip_time > 240 and trip_time <= 9000000 then 1 else 0 end) as over_4H

FROM trip_time_table
group by member_casual
```
Visualization on *Tableau*[](https://github.com/CarlosCandamil/Cyclistic/blob/main/Sheet%204.png)
