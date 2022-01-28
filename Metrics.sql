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
