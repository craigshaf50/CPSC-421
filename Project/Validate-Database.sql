select count(1), 'country' TableCount from country
union
select count(1), 'department' TableCount  from department
union
select count(1), 'gender' TableCount  from gender
union
select count(1), 'genre' TableCount  from genre
union
select count(1), 'keyword' TableCount  from keyword
union
select count(1), 'language' TableCount  from language
union
select count(1), 'language_role' TableCount  from language_role
union
select count(1), 'movie' TableCount  from movie
union
select count(1), 'movie_cast' TableCount  from movie_cast
union
select count(1), 'movie_company' TableCount  from movie_company
union
select count(1), 'movie_crew' TableCount  from movie_crew
union
select count(1), 'movie_genres' TableCount  from movie_genres
union
select count(1), 'movie_keywords' TableCount  from movie_keywords
union
select count(1), 'movie_languages' TableCount  from movie_languages
union
select count(1), 'person' TableCount  from person
union
select count(1), 'production_company' TableCount  from production_company
union
select count(1), 'production_country' TableCount  from production_country

/*
88	country
12	department
3	gender
20	genre
9794	keyword
88	language
2	language_role
4803	movie
106257	movie_cast
13677	movie_company
129581	movie_crew
12160	movie_genres
36162	movie_keywords
11740	movie_languages
104842	person
5047	production_company
6436	production_country
*/