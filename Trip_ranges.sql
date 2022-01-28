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
