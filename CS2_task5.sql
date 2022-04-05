/* task 5 */
/*  additional two more questions */

/* Question 1 */
/*  Names and service time of the police officers who are in charge of the various accidents, grouped by events and officer branches */
/* Why this data? */
/* Here, we need this data so that management is aware of the police officers who are handling the different cases. */
/* This is done so that the hardwork, consistency, perseverence of the officers is recognised. */
/* The management can the reward the deserving officers who handle many cases effectively */
/* Finally, the management can even ensure that the officers are not over-burdened and are not handling multiple cases. */
/* Thus, this data will help in the smooth functioning of the poilice department and improve the efficiency */

/* For this, we will have to add some additional attributes to our star schema as follows */

/* police branch dimension */
DROP TABLE police_branch_dim CASCADE CONSTRAINTS PURGE;

CREATE TABLE police_branch_dim AS
SELECT 
    officer_id,
    officer_fname,
    officer_lname,
    officer_startdate,
    officer_branch
FROM
    ACCIDENT.police_officer;        
        
/* Query Solution */
SELECT 
    COUNT(f."total_number_of_accidents") AS "ACCIDENT COUNT",
    p.officer_id,
    p.officer_fname,
    p.officer_lname,
    p.officer_startdate,
    p.officer_branch
FROM 
    accident_record_fact f JOIN police_branch_dim p
    ON
    p.officer_branch = f.officer_branch
GROUP BY
    p.officer_id,
    p.officer_fname,
    p.officer_lname,
    p.officer_startdate,
    p.officer_branch
ORDER BY
    p.officer_branch;

/* Question 2 */
/* A measure of the vehicle damage severity caused by the different accidents */
/* Why this data? */
/* Here, the management needs this data so that it can keep a tab on the damages caused by the accidents. */
/* This data is for creating public awareness so that people drive safely and carefully. */
/* When these statistics regarding the accidents and their severity are published by the management, the public will be more aware of the damage their negligence and lack of focus can cause. */
/* Hence, this will help prevent further accidents because of increased public awareness */

/* For this, we will have to add some additional attributes */

DROP TABLE accident_record_dim CASCADE CONSTRAINTS PURGE;

CREATE TABLE accident_record_dim AS
SELECT 
    r.accident_no,
    a.accident_event,
    r.vehicle_damage_severity
FROM
    ACCIDENT.accident a,
    ACCIDENT.accident_record r;

/* Query solution */
SELECT 
    COUNT(f."total_number_of_accidents") AS "ACCIDENT COUNT",
    a.vehicle_damage_severity
FROM
    accident_record_fact f JOIN accident_record_dim a ON
    f.accident_no = a.accident_no
GROUP BY
     a.vehicle_damage_severity;
         
    