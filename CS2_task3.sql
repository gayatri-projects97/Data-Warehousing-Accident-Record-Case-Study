/* task 3 */

DROP TABLE accident_time_dim CASCADE CONSTRAINTS PURGE;
DROP TABLE accident_location_dim CASCADE CONSTRAINTS PURGE;
DROP TABLE police_branch_dim CASCADE CONSTRAINTS PURGE;
DROP TABLE vehicle_dim CASCADE CONSTRAINTS PURGE;
DROP TABLE accident_record_dim CASCADE CONSTRAINTS PURGE;
DROP TABLE vehicle_accident_bridge_table CASCADE CONSTRAINTS PURGE;
DROP TABLE temp_fact CASCADE CONSTRAINTS PURGE;
DROP TABLE accident_record_fact CASCADE CONSTRAINTS PURGE;

/* Creating dimension tables */

/* 1) accident time dim */
CREATE TABLE accident_time_dim
(
    time_id NUMBER(7),
    time_desc VARCHAR2(50),
    begin_time DATE,
    end_time DATE
);

/* Inserting values for Day time and Night Time */
INSERT INTO accident_time_dim
VALUES ('1','Day time',TO_DATE('06:00:00','HH24:MI:SS'),TO_DATE('17:59:00','HH24:MI:SS'));
INSERT INTO accident_time_dim
VALUES ('2','Night time',TO_DATE('18:00:00','HH24:MI:SS'),TO_DATE('05:59:00','HH24:MI:SS'));

/* 2) accident location dim */
CREATE TABLE accident_location_dim AS
SELECT DISTINCT
    accident_location_code || accident_suburb AS location_id,
    accident_street,
    accident_suburb
FROM
    ACCIDENT.accident;

/* 3) police branch dimension */
CREATE TABLE police_branch_dim AS
SELECT 
    officer_branch
FROM
    ACCIDENT.police_officer;
  
/* 4b) vehicle dimension */
CREATE TABLE vehicle_dim AS
SELECT DISTINCT
    vehicle_no,
    vehicle_model
FROM
    ACCIDENT.vehicle;

/* vehicle accident bridge table*/
CREATE TABLE vehicle_accident_bridge_table AS
SELECT DISTINCT
    vehicle_no,
    accident_no
FROM
    ACCIDENT.accident_record A;

/* 4a) accident record dimenion */
/* Adding the weight factor and list of attributes as well */
CREATE TABLE accident_record_dim AS
SELECT 
    a.accident_no,
    a.accident_event,
    1.0/(COUNT(v.vehicle_no)) AS "weight_factor",
    LISTAGG(v.vehicle_no,'_') WITHIN GROUP( ORDER BY v.vehicle_no) AS "list_aggregate"
FROM
    ACCIDENT.accident a,
    ACCIDENT.accident_record v
WHERE
    a.accident_no = v.accident_no
GROUP BY
    a.accident_no,
    a.accident_event;
    
/* Creating a temporary fact table */

CREATE TABLE temp_fact AS
    SELECT 
        a.accident_location_code || a.accident_suburb AS location_id,
        a.accident_no,
        a.accident_date_time,
        p.officer_branch
    FROM
        ACCIDENT.accident a,
        ACCIDENT.police_officer p
    WHERE
        a.officer_id = p.officer_id;
        
ALTER TABLE temp_fact
ADD time_id NUMBER(7);

UPDATE temp_fact
SET time_id = 1
WHERE to_char(accident_date_time,'HH24:MI') >= '06:00' 
AND to_char(accident_date_time,'HH24:MI') <= '17:59';

UPDATE temp_fact
SET time_id = 2
WHERE to_char(accident_date_time,'HH24:MI') >= '18:00' 
AND to_char(accident_date_time,'HH24:MI') <= '23:59'; 

UPDATE temp_fact
SET time_id = 2
WHERE to_char(accident_date_time,'HH24:MI') >= '00:00' 
AND to_char(accident_date_time,'HH24:MI') <= '05:59'; 

/* Creating the actual fact table */

CREATE TABLE accident_record_fact AS
SELECT 
    t.time_id,
    t.accident_no,
    t.location_id,
    t.officer_branch,
    COUNT(t.accident_no) AS "total_number_of_accidents"
FROM
    temp_fact t
GROUP BY 
    t.time_id,
    t.accident_no,
    t.location_id,
    t.officer_branch;
