/* task 4 */

/* 4a */
/*  total number of accidents happening by different locations and by different
lighting periods 8 */
 
SELECT
    COUNT(DISTINCT f.accident_no) AS "TOTAL_ACCIDENTS",
    l.accident_suburb,
    t.time_desc
FROM
    accident_record_fact f,
    accident_time_dim t,
    accident_location_dim l
WHERE
    f.time_id = t.time_id
    AND
    f.location_id = l.location_id
GROUP BY
    l.accident_suburb,
    t.time_desc
ORDER BY 
    l.accident_suburb;
  
/* 4b */
/* e total number of accidents by each vehicle model */
SELECT 
    COUNT(DISTINCT a.accident_no) AS "ACCIDENT_COUNT",
    v.vehicle_model
FROM
    accident_record_fact f,
    accident_record_dim a,
    vehicle_accident_bridge_table b,
    vehicle_dim v
WHERE
    f.accident_no = a.accident_no
    AND
    a.accident_no = b.accident_no 
    AND
    v.vehicle_no = b.vehicle_no
GROUP BY
    v.vehicle_model;
    
/* 4c */
/*  number of vehicles involved in every accident event on different locations */
SELECT
    COUNT(b.vehicle_no) AS "VEHICLE_COUNT",
    a.accident_event
FROM
    accident_record_fact f JOIN accident_record_dim a ON
    f.accident_no = a.accident_no 
    JOIN
    vehicle_accident_bridge_table b
    ON
    b.accident_no = a.accident_no
GROUP BY
    a.accident_event;


/* 4d */
/*  number of accidents taken care of by different police officer branches */
SELECT
    COUNT(DISTINCT f.accident_no) AS "ACCIDENT_COUNT",
    p.officer_branch
FROM
    accident_record_fact f,
    police_branch_dim p
WHERE
    f.officer_branch = p.officer_branch
GROUP BY
    p.officer_branch
ORDER BY
    p.officer_branch;
    
    