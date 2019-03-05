/* Grouping adn Pivoting Data 
Grouping Sets
RollUp and Cube
Identifying Groupings in Results
Pivoting Data
Pivot and Unpivot
*/

/* Grouping Sets builds on Group By clause
	Grouping Sets can be by columns or for all rows, use () for all rows 
Roll UP - shortcut for defining grouping sets with combinations that assume input columns form a hierarchy
Cube - shortcut for defining grouping sets in which all possible combinations of grouping set are created
Multiple grouping sets presents a problem in identifying the source of each row in result
NULL come from source data or is a plaeholder in grouping set, unable to identify
Grouping_ID can be use to reolve this issue
*/

Select cat.ParentProductCategoryName, cat.ProductCategoryName, 
	  count(prd.ProductID) as Products
 from SalesLT.vGetAllCategories as cat
Left Join SalesLT.Product as prd
On prd.ProductCategoryID = cat.ProductCategoryID
-- Group By cat.ParentProductCategoryName, cat.ProductCategoryName
-- Group By Grouping Sets (cat.ParentProductCategoryName, cat.ProductCategoryName, ()
-- parenthesis for grand total
-- Group By RollUP (cat.ParentProductCategoryName, cat.ProductCategoryName)
   Group By Cube (cat.ParentProductCategoryName, cat.ProductCategoryName)
   Order By cat.ParentProductCategoryName, ProductCategoryName

-- The one wih grouping ID column
Select  GROUPING_ID(cat.ParentProductCategoryName) as ParentProductCategoryGroup,		       GROUPING_ID(cat.ProductCategoryName) as ProductCategoryGroup,
		cat.ParentProductCategoryName, cat.ProductCategoryName, 
	  count(prd.ProductID) as Products
 from SalesLT.vGetAllCategories as cat
Left Join SalesLT.Product as prd
On prd.ProductCategoryID = cat.ProductCategoryID
-- Group By cat.ParentProductCategoryName, cat.ProductCategoryName
-- Group By Grouping Sets (cat.ParentProductCategoryName, cat.ProductCategoryName, ()
-- parenthesis for grand total
-- Group By RollUP (cat.ParentProductCategoryName, cat.ProductCategoryName)
   Group By Cube (cat.ParentProductCategoryName, cat.ProductCategoryName)
   Order By cat.ParentProductCategoryName, ProductCategoryName


/* Pivoting Data */
Select * From (
Select P.ProductID, PC.Name, IsNUll(P.Color,'Uncolored') As Color
from SalesLT.ProductCategory as PC Join SalesLT.Product As P
ON PC.ProductCategoryID = P.ProductCategoryID) As PPC
Pivot (Count(ProductID) For Color in([Red],[Blue],[Black],[Silver],[Yellow],[Grey],[Multi],[Uncolored]) ) as pvt
ORDER BY Name

/* Unpivoting */
-- Create Temp table
CREATE TABLE #ProductColorPivot
(Name varchar(50), Red int, Blue int, Black int, Silver int, Yellow int, Grey int , multi int, uncolored int);

INSERT INTO #ProductColorPivot
SELECT * FROM
(SELECT P.ProductID, PC.Name,ISNULL(P.Color, 'Uncolored') AS Color
 FROM saleslt.productcategory AS PC
 JOIN SalesLT.Product AS P
 ON PC.ProductCategoryID=P.ProductCategoryID
 ) AS PPC
PIVOT(COUNT(ProductID) FOR Color IN([Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored])) as pvt
ORDER BY Name

Select Name, Color, ProductCount From
(Select *
	-- Name, [Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored]
	from #ProductColorPivot) as pcp
	unpivot
	(ProductCount for Color In( [Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored])) as ProductCounts


