create table movie_trailer
(
    trailer_id int identity(1,1) not null,
    movie_id int not null,
    trailer_name nvarchar(100) not null,
    trailer_description nvarchar(500),
    trailer_length int not null,
    trailer_url nvarchar(1000),
constraint pk_trailer primary key clustered (trailer_id),
constraint fk_trailer_movie foreign key 
(movie_id)
references movie(movie_id)
)

insert into movie_trailer
(movie_id, trailer_name,  trailer_length, trailer_url)
select m.movie_id, concat(m.title, ' trailer'), 0, concat('https://www.movie-trailers.com?trialer_id=', m.movie_id)
from movie m

---Using the movie_trailer table set each trailer_length to 10% of the movie’s runtime
/*
select m.runtime, m.runtime*.1, mt.trailer_length
from movie_trailer mt 
    join movie m on m.movie_id = mt.movie_id
*/

update mt
set mt.trailer_length = .10 * m.runtime
from movie_trailer mt
join movie m on m.movie_id = mt.movie_id

select*
from movie_trailer mt 

---We think that budget is directly impacted by the number of cast and crew. To see 
---whether we’re correct we want to see a result which includes movie title, budget, total cast size, total crew size
select 
    m.movie_id,
    m.title,
    
from movie m 

