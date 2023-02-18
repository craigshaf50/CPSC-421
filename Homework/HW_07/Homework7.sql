---1. Create a table called staging_employee to store the De-normalized data from the employees.csv file. The file can be downloaded from blackboard.
CREATE TABLE staging_employee(
    Employee VARCHAR(100),
    FirstName varchar(50),
    LastName varchar(50),
    EmployeeNumber VARCHAR(10),
    EmailAddress VARCHAR(50),
    WorkPhone VARCHAR(15),
    HomePhone VARCHAR(15),
    Birthday DATE,
    MailAddress1 VARCHAR(50),
    MailAddress2 VARCHAR(50),
    MailCity VARCHAR(50),
    MailState CHAR(2),
    MailPostalCode VARCHAR(15),
    Manager VARCHAR(100),
    Title VARCHAR(50),
    ManagedSince DATE
)



---2. Create a NORMALIZED schema (i.e. a set of tables) to store employee information. Include the attributes listed below. 
--- Include with each column a comment which explains your reason for choosing a specific data type. Also include all necessary primary key and foreign key constraints. 

CREATE TABLE Mailing(
    AddrID int identity(1,1) NOT NULL, -- used int because its an auto incrementing value
    MailAddr1 VARCHAR(50) NOT NULL, -- used varchar because its a string and 50 seems large enough
    MailAddr2 VARCHAR(50) NULL, -- used varchar because its a string and 50 seems large enough
    City VARCHAR(50) NOT NULL, -- used varchar because its a string and 50 seems large enough
    State CHAR(2) NOT NULL, -- used char(2) because it is just state abreviations that are characters
    PostalCode VARCHAR(10) NOT NULL -- postal codes can be 9 digits if you use the +4 zipcode. I used 10 because the 5 digit is commonly separated from the +4 with a hyphen
constraint mailing_pk PRIMARY KEY CLUSTERED 
(
    AddrID
))
CREATE TABLE Position(
    PositionID int identity(1,1) NOT NULL, -- used int because its an auto incrementing value
    Title VARCHAR(50) NOT NULL, -- used varchar because its a string and 50 seems large enough
constraint position_pk PRIMARY KEY CLUSTERED 
(
    PositionID
))

CREATE TABLE Employee(
    EmployeeID int identity(1,1) NOT NULL, -- used int because its an auto incrementing value
    FirstName VARCHAR(50) NOT NULL, -- used varchar because its a string and 50 seems large enough
    LastName VARCHAR(50) NOT NULL, -- used varchar because its a string and 50 seems large enough
    EmployeeNumber VARCHAR(10) NOT NULL, -- used varchar because we arent using these numbers for operations and 10 seems large enough
    EmailAddress VARCHAR(50) NOT NULL, -- used varchar because its a string and 50 seems large enough
    WorkPhone VARCHAR(15) NOT NULL, -- used varcar because we arent using these numbers for operations and 15 seems large enough incase people add extra characters like dashes
    HomePhone VARCHAR(15) NULL, -- used varcar because we arent using these numbers for operations and 15 seems large enough incase people add extra characters like dashes
    Birthday DATE NOT NULL,  -- used date because a birthday is a date
    PositionID int NULL,  -- used int because its an auto incrementing value from the Position table
    AddrID int NULL    -- used int because its an auto incrementing value from the Mailing table
constraint employee_pk PRIMARY KEY CLUSTERED 
(
    EmployeeID
),
CONSTRAINT fk_position FOREIGN KEY (PositionID)
REFERENCES Position (PositionID),
CONSTRAINT fk_mailing FOREIGN KEY (AddrID)
REFERENCES Mailing (AddrID)
)

CREATE TABLE Manager(
    ManagerID int identity(1,1) NOT NULL, -- used int because its an auto incrementing value
    Manager VARCHAR(100) NOT NULL, -- used varchar because its a string and 100 seems large enough for a full name
    EmployeeNumber VARCHAR(10) NOT NULL -- used varchar because we arent using these numbers for operations and 10 seems large enough
constraint manager_pk PRIMARY KEY CLUSTERED 
(
    ManagerID
))
CREATE TABLE ManagerEmployee(
    EmployeeID int NOT NULL, -- used int because its an auto incrementing value from the Employee table
    ManagerID int NOT NULL, -- used int because its an auto incrementing value from the Manager table
    ManagedSince date NULL-- used date because it is a date field
constraint manageremployee_pk PRIMARY KEY CLUSTERED
(
    EmployeeID,
    ManagerID
),
CONSTRAINT fk_employee FOREIGN KEY (EmployeeID)
REFERENCES Employee (EmployeeID),
CONSTRAINT fk_manager FOREIGN KEY (ManagerID)
REFERENCES Manager (ManagerID)
)



---3. Populate the staging_employee table from the data in the employee.csv file (using an insert with literals statement).
---Note: I fixed the data erros while adding them into the table
INSERT INTO staging_employee
(Employee,FirstName, LastName, EmployeeNumber,EmailAddress,WorkPhone,HomePhone,Birthday,MailAddress1,MailAddress2,MailCity,MailState,MailPostalCode,Manager,Title,ManagedSince) VALUES
('Phil Pharmo','Phil','Pharmo', '1', ' phil@gmail.com','5155551212','5155559517','1950-07-25','123 Birch Street',NULL,'Des Moines','IA','50211',NULL,'Owner',NULL),
('Mark Pharmo','Mark','Pharmo','2','mark@outlook.com','5155558965',NULL,'1973-02-23','123 Oak Street',NULL,'Des Moines','IA','50211','Phil Pharmo','Manager Store 1','2000-01-01'),
('Stacy Pharmo','Stacy','Pharmo','3','stacy@hotmail.com','5155556554',NULL,'1977-05-10','123 Linden Street',NULL,'Des Moines','IA','50211','Phil Pharmo','Manager Store 2','2002-02-23'),
('James Smith','James','Smith','2009','james@icloud.com','5155553131',NULL,'1983-01-04','123 Gingko Street',NULL,'Des Moines','IA','50211','Mark Pharmo','Pharmacist','2020-10-01'),
('Kate Jones','Kate','Jones','1980','kate@katesemail.com','5157819845',NULL,'1985-08-13','123 Maple Street',NULL,'Des Moines','IA','50211','Mark Pharmo','Clerk','2018-01-23'),
('Geneva Johnson','Geneva','Johnson','1230','geneva@gmail.com','5158569655',NULL,'1990-09-23','123 Main Street',NULL,'Des Moines','IA','50211','Stacy Pharmo','Pharmacist','2015-04-19'),
('Geneva Johnson','Geneva','Johnson','1230','geneva@gmail.com','5158569655',NULL,'1990-09-23','123 Main Street',NULL,'Des Moines','IA','50211','Mark Pharmo','Pharmacist','2015-04-19'),
('Phil Pharmo','Phil','Pharmo','2010','PhilPharmoIII@gmail.com','5158922323',NULL,'2002-10-14','123 Oak Street',NULL,'Des Moines','IA','50211','Mark Pharmo','Clerk','2022-03-19');



---4. Populate the normalized employee tables with the data from the staging_employee table (using an insert with select statements).
---Mailing table
insert into Mailing(MailAddr1,MailAddr2,City,State,PostalCode)
select distinct
	se.mailaddress1,
	se.mailaddress2,
	se.mailcity,
	se.mailstate,
	se.mailpostalcode
from staging_employee se
---Position table
insert into Position(Title)
select distinct
se.title
from staging_employee se 
---Manager table
insert into Manager(Manager,EmployeeNumber)
select distinct
	se.employee manager,
	se.employeenumber
from staging_employee se 
join staging_employee se1 on se1.manager=se.employee
where se.employeenumber<=3
order by se.employeenumber
---Employee table
insert into employee(FirstName,LastName,EmployeeNumber,EmailAddress,WorkPhone,HomePhone,Birthday,PositionID,AddrID)
select DISTINCT
	se.firstname,
	se.lastname,
	se.employeenumber,
	se.emailaddress,
	se.workphone,
	se.homephone,
	se.birthday,
	p.positionID,
	m.addrID
from staging_employee se
join position p on p.title = se.title
join mailing m on m.mailaddr1 = se.mailaddress1
---ManagerEmployee table
insert into ManagerEmployee(EmployeeID,ManagerID,ManagedSince)
select 
	e.EmployeeID,
	m.ManagerID,
	se.ManagedSince
from staging_employee se
join manager m on m.manager = se.manager 
join employee e on e.employeenumber = se.Employeenumber

---5. Reassign employee 2010 to a new manager, "Stacy Pharmo". Ensure you also update their managed since date.

---query to see who 2010's current manager is 'Mark Pharmo'
/*
select
e.FirstName,
e.lastname, 
e.employeeid,
me.managerid,
m.manager,
me.managedsince
from employee e
join ManagerEmployee me on me.employeeid = e.employeeid
join manager m on m.managerid = me.managerid
where e.employeenumber = '2010'
*/
--- updating the record
update ManagerEmployee
set ManagerID=(select m.managerid from manager m where m.manager = 'Stacy Pharmo'),
    ManagedSince = GETDATE()
where EmployeeID = (select e.employeeid from employee e where e.employeenumber ='2010')

---query to see who 2010's current manager is now 'Stacy Pharmo'
/*
select
e.FirstName,
e.lastname, 
e.employeeid,
me.managerid,
m.manager,
me.managedsince
from employee e
join ManagerEmployee me on me.employeeid = e.employeeid
join manager m on m.managerid = me.managerid
where e.employeenumber = '2010'
*/

---6. Delete  all of Geneva Johnson's data. Ensure your script depicts the deletes in the correct order.

--- Query to see what addrID (4) is Geneva's address before deleting her data from employee (employee has to be removed befor mailing first due to foreign key constraint)
/*
select m.addrid 
from mailing m 
join employee e on e.addrid = m.addrid 
where e.firstname='Geneva'
*/

---delete Geneva's data
DELETE FROM ManagerEmployee where EmployeeID = (select distinct me.employeeid from manageremployee me join employee e on e.employeeid = me.employeeid where e.firstname='Geneva')
DELETE FROM Employee where EmployeeID=(select e.employeeid from employee e where e.firstname='Geneva')
DELETE FROM Mailing where addrid = 4