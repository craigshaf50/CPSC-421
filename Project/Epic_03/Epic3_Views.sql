---Community Review - Views---


--View of Movie Reviews for a movie
--view for Finding Nemo Reviews

CREATE VIEW vw_movie_reviews as 
select
m.title,
r.comment review,
concat(first_name,' ',last_name) username
from review r
join movie m on m.movie_id=r.movie_id
join users u on u.user_id=r.user_id
where m.title = 'Finding Nemo'
GO
--test view
/*
select*from vw_movie_reviews
*/



--View of avg Movie Ratings
CREATE VIEW vw_movie_ratings as 
select
m.title,
avg(r.rating) 'avg rating'
from review r
join movie m on m.movie_id=r.movie_id
group by m.title
GO
--test view
/*
select*from vw_movie_ratings
*/

--View of Movie Reviews and Ratings from a user
CREATE VIEW vw_user_ratings_reviews as 
select
concat(first_name,' ',last_name) username,
m.title,
r.rating,
r.comment review
from review r
join movie m on m.movie_id=r.movie_id
join users u on u.user_id=r.user_id
where concat(first_name,' ',last_name) ='Craig Shaffer'
GO
--test view
/*
select*from vw_user_ratings_reviews
*/
