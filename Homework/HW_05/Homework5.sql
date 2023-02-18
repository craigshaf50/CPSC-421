--- existing table
CREATE TABLE Customer(
    CustomerId int identity(1,1) NOT NULL,
    FirstName varchar(50) NULL,
    LastName varchar(50) NULL,
PRIMARY KEY CLUSTERED 
(
    CustomerId
))
--- add values to customer
INSERT INTO Customer(FirstName,LastName) VALUES
('Craig','Shaffer'),
('Tucker','Shaffer'),
('Peyton','Manning'),
('Von','Miller'),
('George','Paton'),
('Brandon','McManus');



--- 1. Create a table or tables to store Insurance Providers
CREATE TABLE InsuranceProvider(
    ProviderID int identity(1,1) NOT NULL,
    ProviderName varchar(50) NULL,
    BillingAddressLine1 varchar(50) NULL,
    BillingAddressLine2 varchar(50) NULL,
    BillingCity varchar(50) NULL,
    BillingState char(2) NULL,
    BillingZipCode int NULL,
    SupportPhoneNumber int Null,
    BillingPhoneNumber int Null,
constraint pk_provider PRIMARY KEY CLUSTERED 
(
    ProviderId
))



--- 2. Create a table or tables to store customer prescription provider insurance information. Consider that some customers have more than one insurance provider.
CREATE TABLE InsurancePlan(
    PlanID int IDENTITY(1,1) NOT NULL,
    PlanName varchar(50) NOT NULL,
    CopayAmount int NULL,
    ProviderID int NOT NULL,
CONSTRAINT pk_plan PRIMARY KEY CLUSTERED(
    PlanID
),
CONSTRAINT fk_provider FOREIGN KEY (ProviderID)
REFERENCES InsuranceProvider (ProviderID)
)

Create TABLE CustomerPlan(
    MemberID int NOT NULL,
    PlanID int NOT NULL,
CONSTRAINT pk_customer_plan PRIMARY KEY (
    MemberID,
    PlanID
),
CONSTRAINT fk_customer FOREIGN KEY (MemberID)
REFERENCES Customer (CustomerID),
CONSTRAINT fk_plan FOREIGN KEY (PlanID)
REFERENCES InsurancePlan (PlanID)
)



--- 3. Create a script to insert a "default" provider into the insurance provider table. 
--- set default values for InsuranceProvider columns
ALTER TABLE InsuranceProvider ADD CONSTRAINT df_ProviderName DEFAULT 'DEFAULT' FOR ProviderName, 
CONSTRAINT df_Addr1 DEFAULT '' FOR BillingAddressLine1,
CONSTRAINT df_Addr2 DEFAULT '' FOR BillingAddressLine2,
CONSTRAINT df_City DEFAULT '' FOR BillingCity,
CONSTRAINT df_State DEFAULT '' FOR BillingState,
CONSTRAINT df_ZipCode DEFAULT '' FOR BillingZipCode,
CONSTRAINT df_SupportPhone DEFAULT '' FOR SupportPhoneNumber,
CONSTRAINT df_BillingPhone DEFAULT '' FOR BillingPhoneNumber;

--- insert our default provider
INSERT INTO InsuranceProvider DEFAULT VALUES



--- 4. Create a script to insert a default provider for each existing customer.
--- default values for InsurancePlan
ALTER TABLE InsurancePlan ADD CONSTRAINT df_PlanName DEFAULT 'DEFAULT' FOR PlanName,
CONSTRAINT df_CopayAmount DEFAULT 0 for CopayAmount,
CONSTRAINT df_ProviderID DEFAULT 1 for ProviderID;
---NOTE: I chose to call my plan name DEFAULT instead of an empty string
---NOTE: ProviderID is 1 because when the Default provider was the first entry in the InsuranceProvider table and its ProviderID became 1

--- insert our default plan
INSERT INTO InsurancePlan DEFAULT VALUES

---Insert our default provider for each customer in our "joining" table CustomerPlan which joins the Customer and InsurancePlan tables
INSERT INTO CustomerPlan(MemberID,PlanID) VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(5,1),
(6,1);



---5. Write a query which shows the number of customers which are covered by each provider. Include the number of customers which have more than one insurance provider
---number of customers covered by each provider
select 
pr.ProviderName,
count(1) NumberOfCustomers
from InsuranceProvider pr
join InsurancePlan p on p.ProviderId=pr.ProviderID
join CustomerPlan cp on cp.PlanID=P.planID
join Customer c on c.CustomerID=cp.MemberID
group by pr.ProviderName
---NOTE: everyone is only covered by the default provider since we haven't added other providers

---number of providers per customer
select
cp.MemberID,
count(pr.ProviderID) NumberOfProviders
from InsuranceProvider pr
join InsurancePlan p on p.ProviderId=pr.ProviderID
join CustomerPlan cp on cp.PlanID=P.planID
join Customer c on c.CustomerID=cp.MemberID
group by cp.MemberID
---NOTE: each of the 6 customers will only have 1 provider (the default one)

---Number of customers with multiple providers
select
cp.MemberID,
count(pr.ProviderID) NumberOfProviders
from InsuranceProvider pr
join InsurancePlan p on p.ProviderId=pr.ProviderID
join CustomerPlan cp on cp.PlanID=P.planID
join Customer c on c.CustomerID=cp.MemberID
group by cp.MemberID
having count(pr.ProviderID)>1
---NOTE: will return 0 rows because no customer has more than one provider in this example