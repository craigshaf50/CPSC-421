
---Q1. Create procedures for inserting records into each of these tables
--individual,employee,individual_alternate_id,individual_relationship,individual_address,individual_email,individual_phone

CREATE PROCEDURE insert_individual(
    @first_name varchar(50),
    @last_name varchar(50)
)
as
BEGIN
    insert into individual 
    (first_name,last_name)
    values(
    @first_name,
    @last_name
    );
END;
GO

CREATE PROCEDURE insert_employee(
    @individual_id int,
    @title varchar(100),
    @hired_date date,
    @last_date date
)
as
BEGIN
    insert into employee 
    (individual_id,title,hired_date,last_date)
    values(
        @individual_id,
        @title,
        @hired_date,
        @last_date
    );
END;
GO

CREATE PROCEDURE insert_individual_alternate(
    @individual_id int,
    @individual_alternate_id_type_id int,
    @individual_alternate_id varchar(50)
)
as
BEGIN
    insert into individual_alternate_id 
    (individual_id,individual_alternate_id_type_id,individual_alternate_id)
    values(
        @individual_id,
        @individual_alternate_id_type_id,
        @individual_alternate_id
    );
END;
GO

CREATE PROCEDURE insert_individual_relationship(
    @individual_id_child int,
    @individual_id_parent int,
    @individual_relationship_type_id int,
    @relationship_started date,
    @relationship_ended date
)
as
BEGIN
    insert into individual_relationship 
    (individual_id_child,individual_id_parent,individual_relationship_type_id,relationship_started,relationship_ended)
    values(
        @individual_id_child,
        @individual_id_parent,
        @individual_relationship_type_id,
        @relationship_started,
        @relationship_ended
    );
END;
GO

CREATE PROCEDURE insert_individual_address(
    @individual_id int,
    @address_type_id int,
    @address_line_1 varchar(100),
    @address_line_2 varchar(100),
    @city varchar(75),
    @state varchar(2),
    @postal_code varchar(10)
)
as
BEGIN
    insert into individual_address 
    (individual_id,address_type_id,address_line_1,address_line_2,city,state,postal_code)
    values(
        @individual_id,
        @address_type_id,
        @address_line_1,
        @address_line_2,
        @city,
        @state,
        @postal_code
    )
END;
GO

CREATE PROCEDURE insert_individual_phone(
    @individual_id int,
    @phone_type_id int,
    @phone_number varchar(10)
)
as
BEGIN
    insert into individual_phone 
    (individual_id,phone_type_id,phone_number)
    values(
        @individual_id,
        @phone_type_id,
        @phone_number
    )
END;
GO


CREATE PROCEDURE insert_individual_email(
    @individual_id int,
    @email_type_id int,
    @email_address varchar(100)
)
as
BEGIN
    insert into individual_email 
    (individual_id,email_type_id,email_address)
    values(
        @individual_id,
        @email_type_id,
        @email_address
    )
END;
GO
---Q2. Create a procedure called Employee_Insert to add new employees.  Use the procedures created in quesiton 1 to simplify this procedure
--DROP PROCEDURE Employee_Insert;

CREATE PROCEDURE Employee_Insert(
    @first_name varchar(50),
    @last_name varchar(50),
    @title varchar(100),
    @hired_date date,
    @last_date date,
    @individual_alternate_id_type int,
    @individual_alternate_id varchar(50),
    @individual_id_parent int,
    @individual_relationship_type_id int,
    @relationship_started date,
    @relationship_ended date,
    @address_type_id int,
    @address_line_1 varchar(100),
    @address_line_2 varchar(100),
    @city varchar(75),
    @state varchar(2),
    @postal_code varchar(10),
    @email_type_id int,
    @email_address varchar(100),
    @phone_type_id int,
    @phone_number varchar(10),
    @phone_type_id2 int, --- second phone, will only call procedure if not null
    @phone_number2 varchar(10)
)
as 
BEGIN
    declare @individual_id int 
    EXEC insert_individual @first_name, @last_name 
    SET @individual_id = @@IDENTITY
    EXEC insert_employee @individual_id, @title,@hired_date,@last_date
    EXEC insert_individual_alternate @individual_id,@individual_alternate_id_type,@individual_alternate_id
    IF (@individual_id_parent is not null)
        BEGIN
            EXEC insert_individual_relationship @individual_id,@individual_id_parent,@individual_relationship_type_id,@relationship_started,@relationship_ended
        END;
    EXEC insert_individual_address @individual_id,@address_type_id,@address_line_1,@address_line_2,@city,@state,@postal_code
    EXEC insert_individual_email @individual_id,@email_type_id,@email_address
    EXEC insert_individual_phone @individual_id,@phone_type_id,@phone_number
    IF (@phone_type_id2 is not null) -- for inserting the second phone number
        BEGIN 
            EXEC insert_individual_phone @individual_id,@phone_type_id2,@phone_number2
        END;
END;
GO
-- Note: the table for employee has NOT NULL on hired_date and last_date. We do not have data for these columns in employees2.csv. 
-- I added arbitrary dates for hired and last dates. I understand that if I did an if statement to check for null I would be able to pass over the
-- procedure, but then it would not let me insert the title for 'Phil Pharmo'.
-- the inserts for the relationships and types (phone, email, relationship, etc) were all chosen based in the phils-employee-schema-SQL-SERVER.sql file
-- phil has no relationship because he's not managed by anyone and I don't think that mark is his dependent after working there for 20+ years
-- could also be confusion on my part for the understanding of what dependent means in this scenario.

BEGIN TRAN test
EXEC Employee_Insert 'Phil','Pharmo','Owner','1990-01-01','2022-11-14',1,'0001',NULL,NULL,NULL,NULL,1,'123 Birch Street',NULL,'Des Moines','IA','50211',2,'phil@gmail.com',1,'5155551212',2,'5155559517'
select i.individual_id, i.first_name from individual i -- find phil's id
EXEC Employee_Insert 'Mark','Pharmo','Manger Store 1','2000-01-01','2022-11-14',1,'0002',1,1,'2000-01-01',NULL,1,'123 Oak Street',NULL,'Des Moines','IA','50211',2,'mark@outlook.com',1,'5155558965',NULL,NULL
--ROLLBACK TRAN test
COMMIT TRAN test
GO
---3. Create a procedure to update all columns for an address. Use the primary key of the table to identify records to update
/*
I will test this procedure using
Individual Id: 1
Address 1: 123 Cypress St
Address Type Id: 1
Address 2: ''
City: Johnston
State: IA
Postal Code: 50131
*/

--primary key of individual_address is (individual_id, address_type_id)
CREATE PROCEDURE update_address(
    @individual_id int,
    @address_type_id int,
    @address_line_1 varchar(100),
    @address_line_2 varchar(100),
    @city varchar(75),
    @state varchar(2),
    @postal_code varchar(10)
)
as 
BEGIN
    update individual_address
    set
        address_line_1 = @address_line_1,
        address_line_2 = @address_line_2,
        city = @city,
        state = @state,
        postal_code = @postal_code
    where individual_id=@individual_id and address_type_id=1
End;
go

BEGIN TRAN test2
EXEC update_address 1,1,'123 Cypress St','','Johnston','IA','50131'
select*from individual_address
--ROLLBACK TRAN test2
COMMIT TRAN test2
go
---4. Create a view called vw_employee_list which contains the following columns
/*
Employee Number,
Title,
Name (combination of first and last name),
Email Address,
Mobile Phone,
Home Phone,
Mail Postal code,
Manager Name (combination first and last name),
Manager Mobile Phone
*/

CREATE VIEW vw_employee_list as 
select 
    individual_alternate_id 'Employee Number',
    e.title Title,
    CONCAT(i.first_name,' ',i.last_name) Name,
    ie.email_address 'Email Address',
    m_phone.phone_number 'Mobile Phone',
    h_phone.phone_number 'Home Phone',
    iad.postal_code 'Postal Code',
    manager.manager 'Manager Name',
    manager.mobile 'Manager Mobile Phone'
from individual i 
join individual_alternate_id ia on ia.individual_id=i.individual_id
join employee e on e.individual_id=i.individual_id
join individual_email ie on ie.individual_id=i.individual_id
join individual_address iad on iad.individual_id=i.individual_id
left join (select ip.individual_id,ip.phone_number,ip.phone_type_id from individual_phone ip where ip.phone_type_id=1) m_phone on m_phone.individual_id=i.individual_id
left join (select ip.individual_id,ip.phone_number,ip.phone_type_id from individual_phone ip where ip.phone_type_id=2) h_phone on h_phone.individual_id=i.individual_id
left join (select i.individual_id,ir.individual_id_parent,concat(i2.first_name,' ',i2.last_name) manager,ip.phone_number mobile,ip.phone_type_id
from individual i 
    join individual_relationship ir on ir.individual_id_child=i.individual_id 
    join individual i2 on i2.individual_id=ir.individual_id_parent
    join individual_phone ip on ip.individual_id=i2.individual_id where ip.phone_type_id=1) manager on manager.individual_id=i.individual_id
GO

select* from vw_employee_list