/*
Inner, Outer, Cross, Self
Combining rows from multiple tables
Primary Key and Foreign Key

Select .....
From Table 1 JOIN Table 2
	 ON COLUMN

Select ....
From Table1, Table2
where <Clause>

Inner Joins --
Return rows where a match is found in both tables
Join operator is = then it is also called equi join

Select emp.Name, ord.amount from employee as emp [INNER] JOIN 
sales as ord on emp.EmpID = ord.EmpID 

# By default it is Inner Join (Optional , default value of join)
*/

-- Basic Inner Join (Inner is Optional)
select SalesLT.Product.Name As ProductName, SalesLT.ProductCategory.Name As Category From SalesLT.Product INNER JOIN SalesLT.ProductCategory ON SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID


-- Table Aliases
Select p.Name as ProductName, c.Name as Category from SalesLT.Product As p Join SalesLT.ProductCategory as c on p.ProductCategoryID = c.ProductCategoryID

-- Multiple Columns
Select oh.OrderDate, oh.SalesOrderNumber, 
	   p.Name as ProductName, od.OrderQty, od.UnitPrice, od.LineTotal 
From 
		SalesLT.SalesOrderHeader as oh 
join	SalesLT.SalesOrderDetail as od on od.SalesOrderID = oh.SalesOrderID 
join	SalesLT.Product as p on od.ProductID = p.ProductID 
order by oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID

-- multiple tables with multiple predicates

Select oh.OrderDate, oh.SalesOrderNumber, 
	   p.Name as ProductName, od.OrderQty, od.UnitPrice, od.LineTotal 
From 
		SalesLT.SalesOrderHeader as oh 
join	SalesLT.SalesOrderDetail as od on od.SalesOrderID = oh.SalesOrderID 
join	SalesLT.Product as p 
on      od.ProductID = p.ProductID and od.UnitPrice < p.ListPrice -- multiple predicates
order by oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID


/* Outer Join - Return all rows from one table and any matching rows from second table
Left, Right and F�ll, additional rows == NULL 
Left, RIght, and full by default are outer join, no need to specify Outer keyword
*/

Select c.FirstName, c.LastName, oh.SalesOrderNumber
From SalesLT.Customer as c
left outer join SalesLT.SalesOrderHeader as oh
on c.CustomerID = oh.CustomerID
order by  c.CustomerID

Select c.FirstName, c.LastName, oh.SalesOrderNumber
From SalesLT.Customer as c
left outer join SalesLT.SalesOrderHeader as oh
on c.CustomerID = oh.CustomerID
where oh.SalesOrderNumber Is NULL
Order By c.CustomerID

Select p.Name As ProductName, oh.SalesOrderNUmber 
from SalesLT.Product as p
left join SalesLT.SalesOrderDetail as od
on p.ProductID = od.ProductID
left join SalesLT.SalesOrderHeader as oh 
on od.SalesOrderID = oh.SalesOrderID
order by p.ProductID


Select p.Name as ProductName, c.Name as Category, oh.SalesOrderNumber
From SalesLT.Product as p
Left Outer Join SalesLT.SalesOrderDetail as od
on p.ProductID = od.ProductID
Left outer join SalesLT.SalesOrderHeader as oh
on od.SalesOrderID = oh.SalesOrderID
inner join SalesLT.ProductCategory as c
on p.ProductCategoryID = c.ProductCategoryID
order by p.ProductID

/* Cross Join
Combine each row from first table with each row from second table 
Cartesian Product = Cross Join
Logics for Inner and Outer Joins
Inner join starts with cartesian product and adds filter
Outer Join takes cartesian Product, filters and then add back non- matching 
rows with null
*/

Select p.Name, c.FirstName, c.LastName, c.Phone
from SalesLT.Product as p
Cross Join SalesLT.Customer as c

/* Self Join
Compare rows in same table to each other

Select emp.Name as employee, man.Name as manager
From HR.Employee as emp
Left Join HR.Employee as man
on emp.ManagerID = man.EmployeeID
*/


