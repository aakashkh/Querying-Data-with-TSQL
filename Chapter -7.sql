/* Table Expressions - Views, temprory Tables */
/* View =  View of the data, named queries with definitions stored in database */

Create View SalesLT.vCustomerAddress
As
Select c.CustomerID, FirstName, LastName, AddressLine1, City, StateProvince 
from SalesLT.Customer as c JOIN SalesLT.CustomerAddress as CA on C.CustomerID = Ca.CustomerID Join SalesLT.Address as A on CA.AddressID = A.AddressID


Select * from SalesLT.vCustomerAddress

Select c.StateProvince, C.City, IsNULL(Sum(S.TotalDue),0.00) As Revenue from SalesLT.vCustomerAddress as c Left Join SalesLT.SalesOrderHeader as s on s.CustomerID = c.CustomerID group by c.StateProvince, c.City
order by c.StateProvince, Revenue Desc


/* temporary tables
These are used to hold temporary result sets within a user`s session
these are created in tempdb and deleted automaticaly
they are created with a # Prefix
if we need table across multiple session, create with ##

Temporary Variables
Introduced because temporary tables can cause recompilations.
Prefixed with @ sign of type table
Scope in the current batch fo SQL queries
variable should be used on small datasets otherwise takes memory and will makde things slow.
 */

 -- Temporary Table
 Create table #Colors
 (Color varchar(15))

 Insert Into #Colors
 Select Distinct Color from SalesLT.Product

 Select * from #Colors

 -- Table Variables and select all and run
 Declare @Colors as Table (Color varchar(15));
 Insert into @Colors
 Select Distinct Color from SalesLT.Product
 Select * from @Colors

 Select * From #Colors
 -- this will give and error due to scoping of variables
 Select * from @Colors

/* Table Values Functions
These functions returns a table, these are similar to views but are parametrised.
*/

Create Function SalesLt.udfCustomerByCity(@City as varchar(20))
Returns Table
As
Return
(Select C.CustomerID, FirstName, LastName, AddressLine1, City, StateProvince
	From SalesLT.Customer as C Join SalesLT.CustomerAddress as CA
	on C.CustomerID = CA.CustomerID
	Join SalesLT.Address as A on CA.AddressID = A.AddressID
	where City = @City)

Select * from SalesLT.udfCustomerByCity('Bellevue')

/* User Derived  Tables 
Derived tables are names query expression created within an outer select statement
These are not stored in DB
Scope of a derived table is the query in which it is defined and not evn the batch
Must have an Alias
Have unique names for all columns
Not be referred to multiple times in the same query
Do order by with top/offset/fetch only and otherwise do not use.


Ways of defining aliases

Inline
Select * From
(Select Year(orderdate) As orderyear, custId from sales.orders) As Dervied_tables

Externally
Select * From
(Select Year(orderdate), custId from sales.orders) As Dervied_tables(Orderyear, custid)

*/

Select Category, Count(ProductID) As Products From
	(Select p.ProductID, p.Name As Product, c.Name as Category
		From SalesLT.Product as P
		Join SalesLT.ProductCategory as C
		On p.ProductCategoryID = c.ProductCategoryID) as ProdCats
	Group BY Category Order By Category

/* Common table expressions 
Named table expression within a query
Similar to derived tables in scope and naming 
Support multiple references and recursion

For recursion -
Specify a query for root level and then union all to add recursive query
*/

-- Using CTE
With ProductByCategory (ProductID, ProductName, Category)
AS
(Select p.ProductID, P.Name, C.Name As Category
	From SalesLT.Product as p
	Join SalesLT.ProductCategory as C
	On p.ProductCategoryID = C.ProductCategoryID
)
Select Category, Count(ProductID) As Products from ProductByCategory 
group by category order by category

/* Create employee table and Self Join

--note there's no employee table, so we'll create one for this example
CREATE TABLE SalesLT.Employee
(EmployeeID int IDENTITY PRIMARY KEY,
EmployeeName nvarchar(256),
ManagerID int);
GO
-- Get salesperson from Customer table and generate managers
INSERT INTO SalesLT.Employee (EmployeeName, ManagerID)
SELECT DISTINCT Salesperson, NULLIF(CAST(RIGHT(SalesPerson, 1) as INT), 0)
FROM SalesLT.Customer;
GO
UPDATE SalesLT.Employee
SET ManagerID = (SELECT MIN(EmployeeID) FROM SalesLT.Employee WHERE ManagerID IS NULL)
WHERE ManagerID IS NULL
AND EmployeeID > (SELECT MIN(EmployeeID) FROM SalesLT.Employee WHERE ManagerID IS NULL);
GO
 
-- Here's the actual self-join demo
SELECT e.EmployeeName, m.EmployeeName AS ManagerName
FROM SalesLT.Employee AS e
LEFT JOIN SalesLT.Employee AS m
ON e.ManagerID = m.EmployeeID
ORDER BY e.ManagerID;

*/

-- Recursion
Select * from SalesLT.Employee

-- CTE for recursion
With OrgReport(ManagerID, EmployeeID, EmployeeName, Level)
As
(
 -- Anchor QUery
	Select e.ManagerID, e.EmployeeID, e.EmployeeName, 0
	From SalesLT.Employee as e
	where ManagerID is null

	Union all
	-- recursive qery
	Select e.ManagerID, e.EmployeeID, e.EmployeeName, Level + 1
	From SalesLT.Employee as e
	Inner Join OrgReport as o on e.ManagerID= o.EmployeeID
)

Select * From OrgReport

-- To limit recursion
Option (MAXRECURSION 3)

