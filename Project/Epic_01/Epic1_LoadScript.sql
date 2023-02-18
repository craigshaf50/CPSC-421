---Critical Acclaim Load Script---

---load ceremony
insert into ceremony(ceremony_num,award_year)
select distinct
saa.ceremony,
saa.award_year
from stage_AcademyAwards saa
order by ceremony

--load award
insert into award(award_name)
select distinct
saa.award_name
from stage_AcademyAwards saa

--load academy_award
insert into academy_award(ceremony_id,award_id,person_name,winner,film_name)
select distinct
c.ceremony_id,
a.award_id,
saa.person_name,
saa.winner,
case
    when film_name is NULL then 'Film Name not found'
    else film_name
end as film_name
from stage_AcademyAwards saa
join ceremony c on c.ceremony_num=saa.ceremony
join award a on a.award_name=saa.award_name

--load person pct acclaimed
insert into person_acclaim(person_id,acclaim_pct)
select DISTINCT
p.person_id,
case
    when (nominations*1.00)/(isnull(cast_appearance,0)+isnull(crew_appearance,0)) >1 then 1.0  -- some people were nominated more than they were in the database
    else (nominations*1.00)/(isnull(cast_appearance,0)+isnull(crew_appearance,0))
end as acclaim_pct
from person p
left join stage_AcademyAwards saa on p.person_name=saa.person_name
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

--Updating null values to 0.0
update person_acclaim
set acclaim_pct=0.0
where acclaim_pct is NULL

--load job pct acclaimed
insert into job_acclaim (job,acclaim_pct)
select distinct
mc.job,
case
	when (job_nom*1.00/job_app) >1 then 1.0
	else (job_nom*1.00/job_app)
end as acclaim_pct
from movie_crew mc
left join(select
	mc.job,
    count(mc.job) job_nom
	from stage_AcademyAwards saa
	left join movie m on m.title=saa.film_name
	left join movie_crew mc on mc.movie_id=m.movie_id
	left join person p on p.person_name=saa.person_name and p.person_id=mc.person_id
	group by mc.job) nom on nom.job=mc.job
left join (select mc.job,
	count(mc.job) job_app
	from movie_crew mc
	group by mc.job) ap on ap.job=mc.job


update job_acclaim
set acclaim_pct=0.0
where acclaim_pct is NULL

--load cast pct acclaimed
insert into cast_acclaim(cast_order,acclaim_pct)
select distinct
mc.cast_order,
case
	when (cast_nom*1.00/cast_app) >1 then 1.0
	else (cast_nom*1.00/cast_app)
end as acclaim_pct
from movie_cast mc
left join(select mc.cast_order,
	count(mc.cast_order) cast_nom
	from stage_academyawards saa
	left join movie m on m.title=saa.film_name
	left join movie_cast mc on mc.movie_id=m.movie_id
	join person p on p.person_name=saa.person_name and p.person_id=mc.person_id
	group by mc.cast_order) nom on nom.cast_order=mc.cast_order
left join (select mc.cast_order,
	count(mc.cast_order) cast_app
	from movie_cast mc
	group by mc.cast_order) ap on ap.cast_order=mc.cast_order
order by cast_order

update cast_acclaim
set acclaim_pct=0.0
where acclaim_pct is NULL