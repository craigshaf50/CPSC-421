---view practice
/*
create view Lead_Cast_Member as
with mcl as (
select mc.movie_id,
min(mc.cast_order) least_cast_order
from movie_cast mc 
join person p on mc.person_id = p.person_id
group by mc.movie_id
)
select m.movie_id,
m.title,
p.person_name
from movie m
left join mcl on m.movie_id = mcl.movie_id
left join movie_cast mc on mcl.movie_id = mc.movie_id
and mc.cast_order = mcl.least_cast_order
left join person p on mc.person_id = p.person_id
*/
---functions and views
/*
create function dbo.LeadActor(@movie_id int)
returns varchar(500) as
begin
declare @person varchar(500);
select top 1 
@person = p.person_name
from movie_cast mc
    join person p on mc.person_id = p.person_id
where mc.movie_id = @movie_id
order by mc.cast_order asc;
return @person;
end;
*/
--- using function and view
-- function
select m.movie_id,
m.title,
dbo.leadactor(m.movie_id) person_name
from movie m
-- view
select *
from Lead_Cast_Member
