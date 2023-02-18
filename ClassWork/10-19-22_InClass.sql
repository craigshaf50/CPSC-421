---10-19-22
---explore tables
select *
from sys.tables;
---see columns with relationships
select t.name, c.name
from sys.columns c
join sys.tables t on t.object_id = c.object_id;
---in class one
select 
c.country_name,
count(1) movie_count
from movie m
join production_country pc on m.movie_id = pc.movie_id
join country c on pc.country_id = c.country_id
join movie_genres mg on m.movie_id = mg.movie_id
join genre g on mg.genre_id = g.genre_id
where g.genre_name = 'horror'
group by c.country_name
order by movie_count desc

