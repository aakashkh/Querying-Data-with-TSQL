/* Modifying Data
1. Inserting Data
2. Generating Indentifiers
3. Updating Data 
4. Deleting
*/

/* Insert .. Values
 Insert .. Select
 Insert .. Exec
 Select .. Into -- create brand new table, currently not supported in AZURE SQL Database
*/

/* Generating Identifiers
Identity property of a column generates sequential numbers automatically for insertion into a column along with seed and increment values.
1. @@Identity = The last identity generated in session ( can be in any tables)
2. Scope_Identity() = The last identity generated in the current scope ( if multiple tables are altered in the same query the depends on the last table)
3. Ident_Current('TABLE NAME') = The last identity inserted into a table

Using Sequences - 
Generate Sequential Numbers
Select Next Value for () ...
*/

-- Create a table

Create Table SalesLT.Catalog(
CallID int Identity Primary Key Not Null,
CalTime datetime not null Default GetDate(),
SalesPerson nvarchar(256) Not Null,
CustomerID int Not Null References SalesLT.Customer(CustomerID),
PhoneNumber nvarchar(25) Not Null,
Notes nvarchar(max) Null)

-- Select * from SalesLT.Catalog

Insert Into SalesLT.Catalog
Values
('2015-01-01T12:30:00',
'adbventure-works\pamela0',
1,
'144-55-017',
'Hello Word')

--Select * from SalesLT.Catalog

Insert into SalesLT.Catalog
values
(Default, 'adventure-works\david8',2,'180-90-000',NULL)

Select * from SalesLT.Catalog

-- if order is not known (order of the columns)
Insert into SalesLT.Catalog (SalesPerson, CustomerID,PhoneNumber)
values ('a-w/jill',3,'300-40-999')

-- Insert multiple values
Insert into SalesLT.Catalog
values
(DATEADD(mi,-2,GetDate()), 'User 1',4,'80-900-90', NULL),
(Default,'USer 2', 5, '999-99-000','Hello World 2')

-- Insert the results of a query
Insert Into SalesLT.Catalog (SalesPerson, CustomerID,PhoneNumber,Notes)
Select SalesPerson, CustomerID, Phone, 'Promotion'
from SalesLT.Customer
where CompanyName = 'Big-Time Bike Store'

Select * from SalesLT.Catalog

-- Retreive inserted identity
Insert into SalesLT.Catalog (SalesPerson, CustomerID, PhoneNumber)
values
('User 3', 10, '908-777-605')

Select SCOPE_IDENTITY()
Select * From	SalesLT.Catalog

-- Overiding Identity
Set Identity_Insert SalesLT.Catalog ON;

Insert into SalesLT.Catalog (CallID, SalesPerson, CustomerID, PhoneNumber)
Values
(4, 'SQL',11,'900-807655')

Set Identity_Insert SalesLT.Catalog OFF;
Select * from SalesLT.Catalog


/* Update and Deletion 
Update .. Set
Update .. Set .. From

Upsert
Update if records are already there or insert new record if they are not
This can be achieve using Merge
1. when source matched the target
2. when source has no match in target
3. when target has no macth in source

Delete .. Where
Truncate table - clears the entire table
1. Storage physically dellocated, rows not individually removed
2. Minimally logged
3. Can be rolled back if Truncate issues within a transaction
4. Will fail incase table is referenced by a foreign key constraints in another table

If we have foreign key constraints in other tables that references the table we`re deleting from, Delete and Truncate command will fail.
Example, we can delete from customer table but from catalog one, 
hence we can delete from forign key but not on primary side
*/

-- update single column
Update SalesLT.Catalog
Set Notes = 'No Notes' where Notes is NUll

Select * from SalesLT.Catalog

-- update multiple column
Update SalesLT.Catalog Set SalesPerson = '', PhoneNumber = ''
Select * from SalesLT.Catalog

-- update from select statement
Update SalesLT.Catalog
Set SalesPerson = c.SalesPerson, PhoneNumber = c.Phone
from SalesLT.Customer as c
where c.CustomerID = SalesLT.Catalog.CustomerID
Select * from SalesLT.Catalog

-- delete rows and truncate table
Delete from SalesLT.Catalog where CalTime < DATEADD(dd,-7,GetDate())
Select * from SalesLT.Catalog

Truncate table SalesLT.Catalog
Select * from SalesLT.Catalog

-- UPSERT
/*
Merge into production.products as p
using production.productsStaging as S
on.P.ProductID = S.PRoductID
when Matched Then
	Update Set
	P.UnitPrice = S.UnitPrice
	P.Discontinued = S.DIscontinues
when not matched then
	insert(ProductName, CategoryID, UnitPrice, Discontinued)
	values( S.ProductName, S.CategoryID, S.UnitPrice, S.Discontinuesd)
*/