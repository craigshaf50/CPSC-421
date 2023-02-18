select 
m.movie_id,
m.title,
k.keyword_name Tag
from movie m 
join movie_keywords mk on m.movie_id =mk.movie_id
join keyword k on mk.keyword_id =k.keyword_id
union
select 
m.movie_id,
m.title,
g.genre_name Tag
from movie m 
join movie_genres mg on m.movie_id =mg.movie_id
join genre g on mg.genre_id =g.genre_id

select m.title
from movie m
where not exists (
select 1
from movie_cast mc
where mc.movie_id =m.movie_id
) and not exists (
select 1 
from movie_crew mc 
where mc.movie_id =m.movie_id)

