
#sub query named "loco" generates a temporary table with the names, IDs, and a location ID based on latitud. 
WITH Loco AS (SELECT DISTINCT
        start_station_name,
        start_station_id, 
        SUBSTR (ST_GEOHASH(ST_GEOGPOINT(start_lng, start_lat)), 0,9) as start_location_id, ##creates a "location id" based on the Latitude and Logitude of the start station
        FROM 
        `Cyclistic.2021_*`
        WHERE start_station_name IS NOT NULL)
SELECT  
ride_id,	
rideable_type,	
member_casual,	
SUBSTR (ST_GEOHASH(ST_GEOGPOINT(start_lng, start_lat)), 0,9) as start_location_id, ##Creates the location ID on the left(main) table

##the following Join ads the missing start station information by pairing the location IDsbased on latitude and longitude. 
FROM 
`Cyclistic.2021_*` LEFT JOIN Loco ON start_location_id = start_location_id
