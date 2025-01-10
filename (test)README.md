# Cyclistic /Capstone Project 

## Data 
Case Study (Fictional) for the Google data analytics certificate, dataset is from the Chicago city bike program [Dataset](https://divvy-tripdata.s3.amazonaws.com/index.html) 

## Business Task 
- Design marketing strategies aimed at converting casual riders into annual members.
- Understand how annual members and casual riders differ.
- Why casual riders would buy a membership.

## Data Cleaning and Manipulation
- Downloaded 12 .csv files "202101-divvy-tripdata.zip" to "202112-divvy-tripdata.zip" one for each month of 2021 
- Split files "202106-divvy-tripdata.zip" to "202110-divvy-tripdata.zip" into two .csv files each, to enable upload to *BigQuery* (csv size limit 100MB)
- Created dataset Cyclistic on *BibQuery* and uploaded all csv files as tables.

If the case was real there would be a huge potential to better clean and organize the data to get more reliable results,  for instance, the dataset had a lot of null values on the location data, which would be key to better understanding what is going on.
I created a SQL code that can populate these null values based on the latitude and longitude coordinates of bike rides, however, the dataset is too big and the code is too heavy to run with my current BigQuery account capabilities. [null replacement by location](https://github.com/CarlosCandamil/Cyclistic/blob/main/Loco.sql)

### Queries
1.[(Query 1)](https://github.com/CarlosCandamil/Cyclistic/blob/main/Metrics.sql) returns a table with the average **distance traveled** and **Trip duration** aggregated by **User type** (mamber or Casual) and **bike type** (electric or docked/classic). *Tableau* data visualization  **Dashboard 1**
[Metrics](https://github.com/CarlosCandamil/Cyclistic/blob/main/Dashboard%201.png)

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

2. [(Query 2)](https://github.com/CarlosCandamil/Cyclistic/blob/main/Trip_ranges.sql) Returns trip duration ranges. Visualization on *Tableau*[](https://github.com/CarlosCandamil/Cyclistic/blob/main/NotSheet%204.png)

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
3. [Query 3](https://github.com/CarlosCandamil/Cyclistic/blob/main/Top_locations.sql) returns top locations where users are a member or the same for casual. 

4. [Query 4](Top_locations_lat_lng.sql) Returns Latitude and Longitude of the stations by the percentage of member vs casual riders. to be plotted on a Chicago map. 
**Dashboard 2** [Chicago Map](https://github.com/CarlosCandamil/Cyclistic/blob/main/Dashboard%202.png)

```sql
WITH count_of_trips as
   (SELECT ##subquery to count ammount of ride type and members vs casual by starting location
        start_station_id as location_id,
        start_station_name,
        round(start_lat,2) as start_latitude,
        round(start_lng,2) as start_longitude,
        COUNTIF(rideable_type = "electric_bike") as electric_bikes,
        COUNTIF(rideable_type = "classic_bike") as classic_bikes,
        COUNTIF(rideable_type = "docked_bike") as docked_bikes,
        COUNTIF(member_casual = "member") as member,
        COUNTIF(member_casual = "casual") as casual,
        FROM 
        `Cyclistic.2021_*`
        WHERE start_station_id is not null and start_station_name is not null 
        group by location_id, start_station_name,start_latitude, start_longitude)
SELECT ## Converts previous subquery "count of trips" to percentages
location_id,
start_station_name,
start_latitude, start_longitude,
ROUND((classic_bikes + docked_bikes) / (classic_bikes + docked_bikes + electric_bikes)*100,0) AS classic_docked_percent,
ROUND(electric_bikes/(classic_bikes + docked_bikes + electric_bikes)*100,0) AS electric_percent,
ROUND(member/NULLIF(member + casual, 0)*100,0) as member_percent,
ROUND(casual/NULLIF(member + casual, 0)*100,0) as casual_percent
FROM `count_of_trips`
order by member_percent DESC
```

## Analysis 

Analysis was done using SQL (BigQuery) and Tableau, queries were used to create summary tables that help answer the business case...

**Dashboard 1** [(Query 1)](https://github.com/CarlosCandamil/Cyclistic/blob/main/Metrics.sql) [(Query 2)](https://github.com/CarlosCandamil/Cyclistic/blob/main/Trip_ranges.sql) 

- Show how members riders used the bikes more (3.066.000 rides vs 2.529.000 rides) and most rides were classic or docked bikes. 
- Both rider types travel similar average distances however casual riders take a lot more time to cover the same average distance. 

  Casual(Classic 38.84 minutes, Electric 19.34Minutes). 

  Member( Classic 13.66 minutes, Electric 12.2 minutes).

The difference is larger when comparing electric bikes with classic bikes. 

**Dashboard 1** 
![Metrics](https://github.com/CarlosCandamil/Cyclistic/blob/main/Dashboard%201.png) 

**Amount of trips per time range**

![](https://github.com/CarlosCandamil/Cyclistic/blob/main/NotSheet%204.png) 

This shows there is a correlation between casual riders and slow speed, which is larger when using classic bikes. 


**Dashboard 2** 

[Query 4](Top_locations_lat_lng.sql) 
Plotted on a Chicago map shows a heatmap that highlights the areas of the city where riders are more likely to be members. Can be used to target marketing or surveys  [Query 3](https://github.com/CarlosCandamil/Cyclistic/blob/main/Top_locations.sql) Can be used to identify specific top locations where users are majority casual riders. 
 
**Dashboard 2** ![Chicago Map](https://github.com/CarlosCandamil/Cyclistic/blob/main/Dashboard%202.png)

A big part of the analysis could be supported by having two more sets of data that are not present in the dataset; 

1. availability of bikes and bike types on the stations.
2. A member survey with questions on why they use the service, and why they value it. 

The analysis can also improve by taking more time and running a few more specific tests combining both the start and endpoints of trips as I mostly analyze location data on starting stations. 

### Recomendations. 
Based on the analysis I would recommend exploring deeper the correlation between casual riders and long rides as well as the role and availability of electric bikes, this can be done with surveys (asking for bike type preference) and getting system input information on the availability of electric bikes on certain stations.  
The map and the top casual stations can be used to identify locations for the surveys and gathering of more information as well as the target for marketing campaigns. 

