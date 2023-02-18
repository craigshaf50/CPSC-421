-- SQL Server
/*
create table stage_goldenglobe (
id int identity(1,1),
year_film varchar(5),
year_award varchar(5),
ceremony int,
category varchar(200),
nominee varchar(200),
film varchar(200),
winner varchar(10),
constraint pk_stage_goldenglobe
primary key clustered 
(id));
*/
select count(1)
from stage_goldenglobe

select count(distinct movie_id)
from stage_goldenglobe gg 
join movie m on m.title=gg.film

select 
count(distinct mc.person_id)
from stage_goldenglobe gg
join movie m on m.title=gg.film
join movie_cast mc on m.movie_id=mc.movie_id
join person p on mc.person_id = p.person_id and gg.nominee = p.person_name

create table award_nominee
(
award_id int identity(1,1), --IDENTITY
movie_id int not null, -- movie_id from database
Person_id int,
award_category_id int
constraint pk_award_nominee primary key clustered 
(award_id),
constraint fk_award_nominee_movie foreign key 
(movie_id) references movie(movie_id),
constraint fk_award_nominee_person foreign key (person_id) references person(person_id));

create table award_category
(
award_category_id int identity(1,1), --IDENTITY
award varchar(100), -- golden globes/academy award
category varchar(500), -- best actor    
CONSTRAINT pk_award_category primary key clustered (award_category_id)
)


insert into award_category(award, category)
select distinct 'golden globes',
    gg.category
from stage_goldenglobe gg