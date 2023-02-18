---Community Review - Schema & Load Script---
/*
drop table if exists TestStreamer;
drop table if exists review;
drop table if exists user_streamservice;
drop table if exists stream_service
drop table if exists users;
*/
--staging table for data
CREATE TABLE TestStreamer (
    stream_service varchar(50), -- name of streaming service
    service_active int, -- binary classifier to distinguish if provider is actived/inactivated
    first_name varchar(50), --user first name
    last_name varchar(50), -- user last name
    user_age int, -- age of user, used for user demographics
    user_sex char(1), -- M/F, used for user demographics
    user_active int, -- binary classifier to distinguish if user is actived/inactivated
    user_email varchar(50), -- user email address
    user_phone varchar(15), -- user phone number
    movie_name varchar(1000), -- title of film
    rating decimal(3,1), -- rating out of 10 with 1 decimal place
    comment VARCHAR(280) -- comment/review character limit of 280 (same as amount as a tweet on twitter)
)

--load data into TestStreamer
insert into TestStreamer
(stream_service, service_active, first_name, last_name, user_age, user_sex, user_active, user_email, user_phone,movie_name,rating,comment) values
('Netflix',1,'Craig','Shaffer',21,'M',1,'craig.shaffer@gmail.com','9998887777','Star Wars',8.2,'it was pretty good'),
('Netflix',1,'Craig','Shaffer',21,'M',1,'craig.shaffer@gmail.com','9998887777','Finding Nemo',8.5,'it was a great movie'),
('Netflix',1,'Craig','Shaffer',21,'M',1,'craig.shaffer@gmail.com','9998887777','Forrest Gump',9.9,'run forest run'),
('Hulu',1,'Jennifer','Shaffer',26,'F',1,'jen.shaffer@gmail.com','9998882222','Finding Nemo',9.6,'it made me cry'),
('Hulu',1,'Jennifer','Shaffer',26,'F',1,'jen.shaffer@gmail.com','9998882222','Forrest Gump',10.0,'he was running'),
('Netflix',1,'Bill','Bob',38,'M',1,'bobthebillder@gmail.com','7770001234','Finding Nemo',2.2,'there was too much water'),
('Netflix',1,'Bill','Bob',38,'M',1,'bobthebillder@gmail.com','7770001234','Star Wars',7.3,'chewbacca looks like my wife');


-- New Schema Tables
CREATE TABLE stream_service(
    service_id int identity(1,1) NOT NULL,
    service_name varchar(50),
    service_active int
constraint stream_service_pk PRIMARY KEY CLUSTERED (service_id))

CREATE TABLE users (
    user_id int identity(1,1) NOT NULL,
    first_name varchar(50),
    last_name varchar(50),
    age int,
    sex char(1),
    user_active int,
    phone varchar(15),
    email varchar(50),
constraint user_pk PRIMARY KEY CLUSTERED (user_id))

CREATE TABLE user_streamservice (
    service_id int,
    user_id int
constraint user_stream_pk PRIMARY KEY CLUSTERED (service_id,user_id),
CONSTRAINT fk_stream FOREIGN KEY (service_id)
REFERENCES stream_service (service_id),
CONSTRAINT fk_user FOREIGN KEY (user_id)
REFERENCES users (user_id))

CREATE TABLE review (
    user_id int,
    movie_id int,
    rating decimal(3,1), 
    comment VARCHAR(280)
CONSTRAINT review_pk PRIMARY KEY CLUSTERED (movie_id,user_id),
CONSTRAINT fk_movie FOREIGN KEY (movie_id)
REFERENCES movie (movie_id),
CONSTRAINT fk_user2 FOREIGN KEY (user_id)
REFERENCES users (user_id))





--Load Script for new schema tables
insert into stream_service(service_name,service_active)
select
distinct ts.stream_service,
ts.service_active
from TestStreamer ts


insert into users (first_name,last_name,age,sex,user_active,phone,email)
select distinct
ts.first_name,
ts.last_name,
ts.user_age,
ts.user_sex,
ts.user_active,
ts.user_phone,
ts.user_email
from TestStreamer ts

insert into user_streamservice (service_id,user_id)
select distinct
s.service_id,
u.user_id
from TestStreamer ts 
join users u on u.first_name=ts.first_name
join stream_service s on s.service_name=ts.stream_service

insert into review (user_id,movie_id,rating,comment)
select distinct
u.user_id,
m.movie_id,
ts.rating,
ts.comment
from TestStreamer ts 
join users u on u.first_name=ts.first_name
join movie m on m.title=ts.movie_name

