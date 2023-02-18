---Critical Acclaim Schema Script---

/*
drop table if exists stage_AcademyAwards;
*/

--Staging table for Academy Award data to match pipeline schema
CREATE TABLE stage_AcademyAwards(
    award_year VARCHAR(15), -- in the format "1927/1928" which is 9 long 
                            -- format changes to "1934" in 1934 which is 4 long
    ceremony int, -- the number of the ceremony
    award_name VARCHAR(500), -- some awards are long and I chose 500 to be safe
    winner int, --binary classifer for if they won the award or not
    person_name VARCHAR(500), -- some people have long names, the movie database uses 500 for their entries
    film_name VARCHAR(1000) -- the film name, the movie database uses 1000 for their movie titles
)

--Note:
--Even though the variable is called person_name, it is the name of the nominee. Whether it be movie, crew, or person. 


--New Schema tables
CREATE TABLE ceremony(
    ceremony_id int identity(1,1),
    ceremony_num int,
    award_year VARCHAR(15)
constraint ceremony_pk PRIMARY KEY CLUSTERED
(
    ceremony_id
))

CREATE TABLE award(
    award_id int identity(1,1),
    award_name VARCHAR(500)
constraint award_pk PRIMARY KEY CLUSTERED
(
    award_id
))

CREATE TABLE academy_award(
    ceremony_id int,
    award_id int,
    person_name varchar(500),
    winner int,
    film_name varchar(1000)
constraint academy_award_pk PRIMARY KEY CLUSTERED
(
    ceremony_id,award_id,person_name,film_name
),
CONSTRAINT fk_ceremony FOREIGN KEY (ceremony_id) REFERENCES ceremony (ceremony_id),
CONSTRAINT fk_award FOREIGN KEY (award_id) REFERENCES award (award_id))

CREATE TABLE job_acclaim(
    job VARCHAR(200),
    acclaim_pct FLOAT -- value from division (keeping as many decimal places as FLOAT type allows for accuracy)
constraint job_acclaim_pk PRIMARY KEY CLUSTERED
(
    job
))
 
CREATE TABLE cast_acclaim(
    cast_order int,
    acclaim_pct FLOAT -- value from division
constraint cast_acclaim_pk PRIMARY KEY CLUSTERED
(
    cast_order
))

CREATE TABLE person_acclaim(
    person_id int,
    acclaim_pct FLOAT -- value from division
constraint person_acclaim_pk PRIMARY KEY CLUSTERED
(
    person_id
),
CONSTRAINT fk_person_id FOREIGN KEY (person_id) REFERENCES person (person_id))