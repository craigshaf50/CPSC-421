select DISTINCT
p.person_id,
case
    when (nominations*1.00)/(isnull(cast_appearance,0)+isnull(crew_appearance,0)) >1 then 1.0  -- some people were nominated more than they were in the database
    else (nominations*1.00)/(isnull(cast_appearance,0)+isnull(crew_appearance,0))
end as acclaim_pct
from stage_AcademyAwards saa
join person p on p.person_name=saa.person_name
left join (select
	p.person_name,
	count(m.title) crew_appearance
	from movie m
	left join movie_crew mcr on mcr.movie_id=m.movie_id
	join person p on p.person_id=mcr.person_id
	group by p.person_name) cw on cw.person_name=p.person_name
left join (select
	p.person_name,
	count(m.title) cast_appearance
	from movie m
	left join movie_cast mc on mc.movie_id=m.movie_id
	join person p on p.person_id=mc.person_id
	group by p.person_name) ct on ct.person_name=p.person_name
left join (select
    p.person_name,
    count(p.person_name) nominations
    from stage_AcademyAwards saa
    left join person p on p.person_name=saa.person_name
    where p.person_name != ''
    group by p.person_name) nom on nom.person_name=p.person_name
where p.person_name != ''

