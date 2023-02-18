---Community Review - Stored Procedures---

--streaming service add, edit, inactivate
CREATE PROCEDURE  stream_service_add(
    @service_name varchar(50),
    @service_active int
)
as
BEGIN
    insert into stream_service 
    (service_name,service_active)
    values(
    @service_name,
    @service_active
    );
END;
GO

CREATE PROCEDURE  stream_service_edit(
    @service_id int,
    @service_name varchar(50),
    @service_active int
)
as
BEGIN
    update stream_service
    set
        service_name = @service_name,
        service_active = @service_active
    where service_id=@service_id
END;
GO

CREATE PROCEDURE stream_service_inactivate(
    @service_id int
)
as
BEGIN
    update stream_service
    set
        service_active = 0
    where service_id=@service_id
END;
GO
--tests for stream service procedures
/*
BEGIN TRAN test
EXEC stream_service_add 'DisneyPlus',1
select*from stream_service
EXEC stream_service_edit 3,'Disney Plus',1
select*from stream_service
EXEC stream_service_inactivate 3
select*from stream_service
ROLLBACK TRAN test
*/



--users add, edit, inactivate
CREATE PROCEDURE  user_add(
    @first_name varchar(50),
    @last_name varchar(50),
    @age int,
    @sex char(1),
    @user_active int,
    @phone varchar(15),
    @email varchar(50)
)
as
BEGIN
    insert into users 
    (first_name,last_name,age,sex,user_active,phone,email)
    values(
    @first_name,
    @last_name,
    @age,
    @sex,
    @user_active, 
    @phone, 
    @email
    );
END;
GO

CREATE PROCEDURE  user_edit(
    @user_id int,
    @first_name varchar(50),
    @last_name varchar(50),
    @age int,
    @sex char(1),
    @user_active int,
    @phone varchar(15),
    @email varchar(50)
)
as
BEGIN
    update users 
    set 
        first_name=@first_name,
        last_name=@last_name,
        age=@age,
        sex=@sex,
        user_active=@user_active, 
        phone=@phone, 
        email=@email
    where user_id=@user_id
END;
GO

CREATE PROCEDURE  user_inactivate(
    @user_id int
)
as
BEGIN
    update users 
    set 
        user_active=0 
    where user_id=@user_id
END;
GO

--tests for user procedures
/*
BEGIN TRAN test2
EXEC user_add 'Debbie','Brown',62,'F',1,'5552221111','debrown1960@yahoo.com'
select*from users
EXEC user_edit 4,'Deborah','Brown',62,'F',1,'5552221111','debrown1960@yahoo.com'
select*from users
EXEC user_inactivate 4
select*from users
ROLLBACK TRAN test2
*/



--NOTE: The ratings and reviews are stored in the same table (review) for my project. I did this because most times you review something you are asked to comment/review why you gave it that score.
-- Becuase of this, I will make one procedure doing both for each add, edit, and removing. Below these procedures, I'll include individual review and rating procedures if thats what you were looking for.

-- user rating and review add,edit,remove
CREATE PROCEDURE  review_add(
    @user_id int,
    @movie_id int,
    @rating decimal(3,1),
    @comment varchar(280)
)
as
BEGIN
    insert into review
    (user_id,movie_id,rating,comment)
    values(
        @user_id,
        @movie_id,
        @rating,
        @comment
    );
END;
GO

CREATE PROCEDURE  review_edit(
    @user_id int,
    @movie_id int,
    @rating decimal(3,1),
    @comment varchar(280)
)
as
BEGIN
    update review
    set 
        rating=@rating,
        comment=@comment
    where user_id=@user_id and movie_id=@movie_id
END;
GO

CREATE PROCEDURE  review_remove(
    @user_id int,
    @movie_id int
)
as
BEGIN
    delete from review
    where user_id=@user_id and movie_id=@movie_id
END;
GO

--tests for review procedures
/*
BEGIN TRAN test3
EXEC review_add 2,5,8.2,'good movie'
select*from review
EXEC review_edit 2,5,2.6,'it sucked'
select*from review
EXEC review_remove 2,5
select*from review
ROLLBACK TRAN test3
*/

--procedures for user rating and user review on their own, even though they are in the same table for my schema
CREATE PROCEDURE  userrating_add(
    @user_id int,
    @movie_id int,
    @rating decimal(3,1)
)
as
BEGIN
    insert into review
    (user_id,movie_id,rating,comment)
    values(
        @user_id,
        @movie_id,
        @rating,
        NULL
    );
END;
GO

CREATE PROCEDURE  userrating_edit(
    @user_id int,
    @movie_id int,
    @rating decimal(3,1)
)
as
BEGIN
    update review
    set 
        rating=@rating
    where user_id=@user_id and movie_id=@movie_id
END;
GO

CREATE PROCEDURE  userrating_remove(
    @user_id int,
    @movie_id int
)
as
BEGIN
    update review
    set 
        rating=NULL
    where user_id=@user_id and movie_id=@movie_id
END;
GO

CREATE PROCEDURE  userreview_add(
    @user_id int,
    @movie_id int,
    @comment varchar(280)
)
as
BEGIN
    insert into review
    (user_id,movie_id,rating,comment)
    values(
        @user_id,
        @movie_id,
        NULL,
        @comment
    );
END;
GO

CREATE PROCEDURE  userreview_edit(
    @user_id int,
    @movie_id int,
    @comment varchar(280)
)
as
BEGIN
    update review
    set 
        comment=@comment
    where user_id=@user_id and movie_id=@movie_id
END;
GO

CREATE PROCEDURE  userreview_remove(
    @user_id int,
    @movie_id int
)
as
BEGIN
    update review
    set 
        comment=NULL
    where user_id=@user_id and movie_id=@movie_id
END;
GO

--tests for individual rating and review procedures
/*
BEGIN TRAN test4
EXEC userrating_add 2,5,8.2
select*from review
EXEC userrating_edit 2,5,2.6
select*from review
EXEC userrating_remove 2,5
select*from review
ROLLBACK TRAN test4

BEGIN TRAN test5
EXEC userreview_add 2,5,'good movie'
select*from review
EXEC userreview_edit 2,5,'it sucked'
select*from review
EXEC userreview_remove 2,5
select*from review
ROLLBACK TRAN test5
*/