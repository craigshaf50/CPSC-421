drop table if exists employee;
drop table if exists individual_alternate_id;
drop table if exists individual_relationship;
-- ---------------------------------------------------------------------Reset/Drop Tables-----------------------------------------------------------------
drop table if exists individual_address;
drop table if exists individual_phone;
drop table if exists individual_email;
drop table if exists individual;
drop table if exists individual_alternate_id_type;
drop table if exists individual_relationship_type;
drop table if exists address_type;
drop table if exists phone_type;
drop table if exists email_type;


-- ---------------------------------------------------------------------Type Tables-----------------------------------------------------------------

create table individual_alternate_id_type
(
	individual_alternate_id_type_id int not null,
	individual_alternate_id_type_name varchar(100) not null,
	constraint pk_alternate_type primary key (individual_alternate_id_type_id)
);

create table individual_relationship_type
(
	individual_relationship_type_id int not null,
	individual_relationship_type_name varchar(100) not null,
	constraint pk_individual_relationship_type primary key (individual_relationship_type_id)
);

create table address_type
(
	address_type_id int not null,
	address_type_name varchar(100) not null,
	constraint pk_individual_address_type primary key (address_type_id)
);

create table phone_type
(
	phone_type_id int not null,
	phone_type_name varchar(100) not null,
	constraint pk_phone_type primary key (phone_type_id)
);

create table email_type
(
	email_type_id int not null,
	email_type_name varchar(100) not null,
	constraint pk_email_type primary key (email_type_id)
);

-- ---------------------------------------------------------------------Type Values-----------------------------------------------------------------

insert into individual_alternate_id_type
(
    individual_alternate_id_type_id,
    individual_alternate_id_type_name
)
values
(   1, -- individual_alternate_id_type_id - int
    'Employee_Number' -- individual_alternate_id_type_name - varchar(100)
    ),
(   2, -- individual_alternate_id_type_id - int
    'Social Security Number' -- individual_alternate_id_type_name - varchar(100)
    );
    
insert into individual_relationship_type
(
    individual_relationship_type_id,
    individual_relationship_type_name
)
values
(   1, -- individual_relationship_type_id - int
    'Manager' -- individual_relationship_type_name - varchar(100)
    ),
(   2, -- individual_relationship_type_id - int
    'dependent' -- individual_relationship_type_name - varchar(100)
    );
    
insert into address_type
(
    address_type_id,
    address_type_name
)
values
(   1, -- address_type_id - int
    'Mailing Address' -- address_type_name - varchar(100)
    ),
(   2, -- address_type_id - int
    'Shipping Address' -- address_type_name - varchar(100)
    );

insert into phone_type
(
    phone_type_id,
    phone_type_name
)
values
(   1, -- phone_type_id - int
    'Mobile' -- phone_type_name - varchar(100)
    ),
(   2, -- phone_type_id - int
    'Home' -- phone_type_name - varchar(100)
    ),
(   3, -- phone_type_id - int
    'Work' -- phone_type_name - varchar(100)
    );

insert into email_type
(
    email_type_id,
    email_type_name
)
values
(   1, -- email_type_id - int
    'individualal email' -- email_type_name - varchar(100)
    ),
(   2, -- email_type_id - int
    'work email' -- email_type_name - varchar(100)
    );
-- ---------------------------------------------------------------------Data Model-----------------------------------------------------------------
create table individual
(
	individual_id int identity(1,1),
	last_name varchar(50) not null,
	first_name varchar(50) not null,
	constraint pk_individual primary key
	(individual_id)
);

create table employee
(
	individual_id int not null,
	title varchar(100) not null,
	hired_date date not null,
	last_date date not null,
	constraint pk_employee primary key
	(individual_id)
);


create table individual_alternate_id
(
	individual_id int not null,
	individual_alternate_id_type_id int not null,
	individual_alternate_id varchar(50) not null,
	constraint pk_alternate_id primary key 
		(individual_id, individual_alternate_id_type_id),
	constraint fk_individual_alternate_id_individual foreign key (individual_id)
	references individual (individual_id),
	constraint fk_individual_alternate_id_individual_alternate_id_type foreign key (individual_alternate_id_type_id)
	references individual_alternate_id_type (individual_alternate_id_type_id)
);


create table individual_relationship
(
	individual_id_child int not null,
	individual_id_parent int not null,
	individual_relationship_type_id int not null,
	relationship_started date not null,
	relationship_ended date,
	constraint pk_individual_relationship primary key
		(individual_id_child, individual_id_parent, individual_relationship_type_id),
	constraint fk_individual_relationship_child_individual foreign key (individual_id_child)
	references individual (individual_id),
	constraint fk_individual_relationship_parent_individual foreign key (individual_id_parent)
	references individual (individual_id),
	constraint fk_individual_relationship_individual_relationship_type foreign key (individual_relationship_type_id)
	references individual_relationship_type (individual_relationship_type_id)
);

create table individual_address
(
	individual_id int not null,
	address_type_id int not null,
	address_line_1 varchar(100) not null,
	address_line_2 varchar(100),
	city varchar(75) not null,
	state varchar(2) not null,
	postal_code varchar(10) not null,
	constraint pk_individual_address primary key 
		(individual_id, address_type_id),
	constraint fk_individual_address_individual  foreign key (individual_id)
	references individual (individual_id),
	constraint fk_individual_address_individual_address_type foreign key (address_type_id)
	references address_type (address_type_id)
);

create table individual_phone
(
	individual_id int not null,
	phone_type_id int not null,
	phone_number varchar(10) not null,
	constraint pk_individual_phone primary key 
		(individual_id, phone_type_id),
	constraint fk_individual_phone_individual foreign key (individual_id)
	references individual (individual_id),
	constraint fk_individual_phone_phone_type foreign key (phone_type_id)
	references phone_type (phone_type_id)
);



create table individual_email
(
	individual_id int not null,
	email_type_id int not null,
	email_address varchar(100) not null,
	constraint pk_individual_email primary key 
		(individual_id, email_type_id),
	constraint fk_individual_email_individual foreign key (individual_id)
	references individual (individual_id),
	constraint fkindividual_email_email_type foreign key (email_type_id)
	references email_type (email_type_id)
);


