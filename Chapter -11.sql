/* Errors and Transaction 
Error Number
Error Message
Severity (Nos - 1-10, are infromational messages
State
Procedure
Line Number

1. RAISEERROR - raise an explicit error message, serverity and state
2. Throw - replacement of raiseerror
	custom error number should be greater than 50000
*/

-- system error
Insert into SalesLT.SalesOrderDetail (SalesOrderID, OrderQty,ProductID, UnitPrice, UnitPriceDiscount) values (100000,1,680,1431.5,0.00)

-- raise an error with raiseerror
update SalesLT.Product
Set DiscontinuedDate = GETDATE()
where ProductID = 0
 if @@ROWCOUNT < 1
 RAISERROR('No product updated', 16,0)

 -- throw statement

update SalesLT.Product
Set DiscontinuedDate = GETDATE()
where ProductID = 0
 if @@ROWCOUNT < 1
 Throw 50000, 'no product updated', 0

/* catching error - exceptional handling 
Use Try .. catch block */

Begin Try
	Update SalesLT.Product
	Set ProductNumber = ProductID /ISNULL(weight, 0)
end try
begin catch 
	Print 'The folowing error occured'
	print Error_Message()
end catch

-- catch and retrow
Begin Try 
	Update SalesLT.Product
	Set ProductNumber = ProductID /ISNULL(weight, 0)
end try
begin catch 
	Print 'The folowing error occured'
	print Error_Message() ;
	THROW
end catch

-- catch, log and throw a custom error in a DB using a stored procedure

Begin Try 
	Update SalesLT.Product
	Set ProductNumber = ProductID /ISNULL(weight, 0)
end try
begin catch 
	Declare @ErrorLogID as int, @ErrorMsg as varchar(250)
	execute dbo.uspLogError @ErrorLogID Output
	Set  @ErrorMsg = 'View error # ' + Cast(@ErrorLogID  as varchar) + 'in error log';
	THROW 50001, @ErrorMsg, 0
end catch

Select * From dbo.ErrorLog 

/* Transaction 
Group of tasks defining a unit of work
The entire unit must success of fail together - no partial completion is permitted.
Example - transferring funds from one bank to another, situation should not be like credit
from one but not debited to other, it should happend both

If a insert statement of 10,000 rows failed at 5000, SQL server look out for consistency in 
that. Individual data modification statements are automatically treated as standalone
transactions

Locking mechanisms - while transaction happens, other queries should work
Begin Transaction .. Commit Transaction
RollBack Transation or enable XACT_Abort() to automatically rollbac on any error
@@Trancount for transaction count and XACT_State() to check transaction status
*/

-- No Transaction

Begin Try
	Insert into SalesLT.SalesOrderHeader (DueDate, CustomerID, ShipMethod)
	Values (DATEADD(dd,7, GetDate()),1,'Std Delivery')

	Declare @SalesOrderID int = Scope_identity()
	
	Insert into SalesLT.SalesOrderDetail (SalesOrderID,OrderQty,ProductID,UnitPrice, UnitPriceDiscount)
	Values
	(@SalesOrderID,1,99999,1431.5,0)
end try
begin catch 
	print error_message()
end catch

--check
Select h.SalesOrderID, h.DueDate, h.CustomerID, h.ShipMethod, d.SalesOrderDetailID
From SalesLT.SalesOrderHeader as h
left join SalesLT.SalesOrderDetail as d
on d.SalesOrderDetailID = h.SalesOrderID
where d.SalesOrderDetailID is Null

--Delete from SalesLT.SalesOrderHeader where SalesOrderID = 1

-- with transaction

Begin Try
	Begin Transaction
	Insert into SalesLT.SalesOrderHeader (DueDate, CustomerID, ShipMethod)
	Values (DATEADD(dd,7, GetDate()),1,'Std Delivery')

	Declare @SalesOrderID int = Scope_identity()
	
	Insert into SalesLT.SalesOrderDetail (SalesOrderID,OrderQty,ProductID,UnitPrice, UnitPriceDiscount)
	Values
	(@SalesOrderID,1,99999,1431.5,0)
	Commit Transaction
end try
begin catch 
	if @@TRANCOUNT > 0
	Begin Print XACT_STATE();
	Rollback transaction
	end
	print error_message();
	throw 50001, 'Cancelled! Cancelled!', 0
end catch

-- check
Select h.SalesOrderID, h.DueDate, h.CustomerID, h.ShipMethod, d.SalesOrderDetailID
From SalesLT.SalesOrderHeader as h
left join SalesLT.SalesOrderDetail as d
on d.SalesOrderDetailID = h.SalesOrderID
where d.SalesOrderDetailID is Null

-- XACT ABort
Set XACT_ABORT ON
Begin Try
	Begin Transaction
	Insert into SalesLT.SalesOrderHeader (DueDate, CustomerID, ShipMethod)
	Values (DATEADD(dd,7, GetDate()),1,'Std Delivery')

	Declare @SalesOrderID int = Scope_identity()
	
	Insert into SalesLT.SalesOrderDetail (SalesOrderID,OrderQty,ProductID,UnitPrice, UnitPriceDiscount)
	Values
	(@SalesOrderID,1,99999,1431.5,0)
	Commit Transaction
end try
begin catch 
--	if @@TRANCOUNT > 0
--	Begin Print XACT_STATE();
--	Rollback transaction
--	end
	print error_message();
	throw 50001, 'Cancelled! Cancelled!', 0
end catch
Set XACT_ABORT OFF

Select h.SalesOrderID, h.DueDate, h.CustomerID, h.ShipMethod, d.SalesOrderDetailID
From SalesLT.SalesOrderHeader as h
left join SalesLT.SalesOrderDetail as d
on d.SalesOrderDetailID = h.SalesOrderID
where d.SalesOrderDetailID is Null