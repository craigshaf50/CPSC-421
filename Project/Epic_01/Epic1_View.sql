---Critical Acclaim Probability View---

--view contains movie_id, title, acclaim pct (probability of being acclaimed based on members of cast/crew)
CREATE VIEW vw_movie_acclaim_pct
as
with acclaim as (
select
mcw.movie_id,
mcw.person_id,
mcw.job,
(ja.acclaim_pct*pa.acclaim_pct) acclaim_pct
from movie_crew mcw 
join job_acclaim ja on ja.job=mcw.job
join person_acclaim pa on pa.person_id=mcw.person_id
union
select
mct.movie_id,
mct.person_id,
CONVERT(varchar(5), mct.cast_order),
(ca.acclaim_pct*pa.acclaim_pct) acclaim_pct
from movie_cast mct 
join cast_acclaim ca on ca.cast_order=mct.cast_order
join person_acclaim pa on pa.person_id=mct.person_id
)
select 
m.movie_id,
m.title,
sum(acclaim.acclaim_pct) acclaim_pct
from movie m
join acclaim on acclaim.movie_id=m.movie_id
group by m.title, m.movie_id
GO


--call the view
select*from vw_movie_acclaim_pct