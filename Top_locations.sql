WITH count_of_trips as
   (SELECT ##subquery to count ammount of ride type and members vs casual by starting location
        start_station_id as location_id,
        start_station_name,
        COUNTIF(rideable_type = "electric_bike") as electric_bikes,
        COUNTIF(rideable_type = "classic_bike") as classic_bikes,
        COUNTIF(rideable_type = "docked_bike") as docked_bikes,
        COUNTIF(member_casual = "member") as member,
        COUNTIF(member_casual = "casual") as casual,
        FROM 
        `Cyclistic.2021_*`
        group by location_id, start_station_name)
SELECT ## Converts previous subquery "count of trips" to percentages
location_id,
start_station_name,
ROUND((classic_bikes + docked_bikes) / (classic_bikes + docked_bikes + electric_bikes)*100,0) AS classic_docked_percent,
ROUND(electric_bikes/(classic_bikes + docked_bikes + electric_bikes)*100,0) AS electric_percent,
ROUND(member/NULLIF(member + casual, 0)*100,0) as member_percent,
ROUND(casual/NULLIF(member + casual, 0)*100,0) as casual_percent
FROM `count_of_trips`
order by member_percent DESC
