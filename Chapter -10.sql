/* Programming Overview 
Batches, variables, Conditions, Loops and Stored Procedures

1. Batches are set of commands sent to SQL Server as a unit. They detrmine variable scope.
  To separate statements into batches, use separator, SQL server uses GO but is not an T-SQL Command.
  Go [Count] execute the batch specified no. of times

2. Variables
   Defined by Declare keyword
   Variables with default value
   Decalre @color nvarchar(15) = 'Black', @size nvarchar(5) = 'L', 
   Variables are always local to batch
*/

Declare @City Varchar(20) = 'Toronto'
Go
-- Go creates a new batch and hence will get an error
Select FirstName+' '+LastName as [Name], AddressLine1 as Address, City
From SalesLT.Customer as C
Join SalesLT.CustomerAddress as CA
on c.CustomerID = CA.CustomerID
Join SalesLT.Address as A
On CA.AddressID = A.AddressID
where City = @City 

Declare @City Varchar(20) = 'Toronto'
-- No Go separater won`t create a  new batch and hence will get executed successfully
Select FirstName+' '+LastName as [Name], AddressLine1 as Address, City
From SalesLT.Customer as C
Join SalesLT.CustomerAddress as CA
on c.CustomerID = CA.CustomerID
Join SalesLT.Address as A
On CA.AddressID = A.AddressID
where City = @City 

-- declare variable with default value
Declare @City Varchar(20) = 'Toronto'
-- pass anew value to variable
Set @City = 'Bellevue' 
Select FirstName+' '+LastName as [Name], AddressLine1 as Address, City
From SalesLT.Customer as C
Join SalesLT.CustomerAddress as CA
on c.CustomerID = CA.CustomerID
Join SalesLT.Address as A
On CA.AddressID = A.AddressID
where City = @City 

-- Use variable to store output
Declare @Result as money
Select @Result = Max(TotalDue) -- directly pass to select statement
From SalesLT.SalesOrderHeader

Print @Result

/* Conditions 
If @color is Null 
Select * from product
Else Select * from Product where Color = @color
*/

If 'Yes' = 'No' Print 'True' Else Print 'False'

Update SalesLT.Product
Set DiscontinuedDate = GETDATE()
Where ProductID = 680

If @@ROWCOUNT > 0
-- Enclose multiple statements in IF and Else clause under begin and end keywords
Begin
	Print 'Not Found'
End
Else 
Begin
	Print 'Found'
End

/* Looping  - While, End, Break and Continue*/
/*
Declare @Counter int =1
while @counter <=5
begin
	Insert SalesLT.DemoTable(Description)
	Values('Row'+Convert(varchar(5), @counter))
	Set @counter += 1
End
Select * from SalesLt.DemoTable
*/

-- the above operation is row based operation and not set based

-- Stored Procedures
/* Database objects that encapsulate TSQL code
These can be parameterized and are executed with execute command */

Create Procedure SalesLT.GetProductByCategory (@CategoryID Int = NUll)
as If @CategoryID Is null
	Select ProductID, Name, Color, Size, ListPrice from salesLT.Product
else
	Select ProductID, Name, Color, Size, ListPrice
	From SalesLT.Product
	Where ProductCategoryID = @CategoryID

Exec SalesLT.GetProductByCategory
-- exec is not required if it is the first line of code

Exec SalesLT.GetProductByCategory 6

/*
The function must return a value but in Stored Procedure it is optional. Even a procedure can return zero or n values. Functions can have only input parameters for it whereas Procedures can have input or output parameters. Functions can be called from Procedure whereas Procedures cannot be called from a Function.

Source - Google - DotNetTRicks 

*/