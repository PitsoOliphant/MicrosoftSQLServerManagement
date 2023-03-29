/*Add a secondary filegroup to the Northwind database and add
a file named nwdata2 to the secondart filegroup that matches the properties
of the primary data file. The file, to store in "C:\SQLDATA\Northwind"
folder, should be initially, 20MB in size, grow by 5% but no exceed 1GB*/
ALTER DATABASE Northwind
ADD FILEGROUP Secondary
ALTER DATABASE Northwind
ADD FILE
(NAME=nwdata2,
FILENAME='C:\SQLDATA\Northwind\nwdata2.ndf',
SIZE=20MB,
FILEGROWTH=5%,
MAXSIZE=1GB)

/*Create a table called Addresses.
1)AddressID is the primary key and values will auto-incrememtn by 1 starting from 201
2)Allow null values on the customerID; the rest of the columns cannot contain nulls
3)The CustomerID must have 5 letters and must be a foreing key to the Custmoers table*/
CREATE TABLE Addresses
(AddressID INT IDENTITY(201,1) PRIMARY KEY,
CustomerID NCHAR(5)  REFERENCES Customers(CustomerID)  NULL,
Street VARCHAR(100) NOT NULL,
City VARCHAR(50) NOT NULL,
PostCode NVARCHAR(10) NOT NULL,
Country VARCHAR(50) NOT NULL)

/*Enforce the following changes to the Northwind database tables
a) Add a constraint to prevent duplicate category names in the Category tables
b)Ensure that the OrderDate is the current date if no order date is given
c)Ensure that the ShippedDate cannot be earlier than the OrderDate
d)Create a non-clustered index on the Country column in the Addresses table 
e)Create a composite index on the City and PostCode in the Addresses table
*/
ALTER TABLE Categories
ADD CONSTRAINT UC_CategoryName UNIQUE(CategoryName)

ALTER TABLE Orders
ADD CONSTRAINT DF_OrderDate  DEFAULT  GETDATE() FOR OrderDate

ALTER TABLE Orders
ADD CONSTRAINT CK_ShippedDate CHECK(ShippedDate>OrderDate)

ALTER TABLE Orders
DROP  [CK_ShippedDate]

CREATE NONCLUSTERED INDEX Country
ON Addresses (Country)

CREATE NONCLUSTERED INDEX CompositeIndex
ON Addresses(City,PostCode)

/*Show the first top 3 employees to get hired*/
SELECT TOP(3)FirstName,LastName,HireDate
FROM Employees
ORDER BY HireDate ASC

/*Display countries without any duplicates*/
SELECT DISTINCT Country
FROM Employees

/*Display a list of suppliers that are not from the UK,FRANCE,Germany or USA
show the company name lablled Supplier Name*/
SELECT CompanyName AS'Supplier Name'
FROM Suppliers
WHERE Country NOT IN('UK','France','USA','Germany')

/*Show the product name and unit price of all products with a price range of R100 to R150
sorted in descending order of price*/
SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 100 AND 150
ORDER BY UnitPrice DESC

/*Display company with the column heading 'Customer Name', contact name
, contact title and phone for all customer contact who are managers*/
SELECT CompanyName AS'Customer Name',ContactName,ContactTitle, Phone
FROM Customers
WHERE ContactTitle LIKE'%Manager'

/*Show the country and number of customers per country*/
SELECT Country,COUNT(CompanyName)AS'Number of customers per country'
FROM Customers
GROUP BY Country

/*Display the CategoryID, number of products, the lowest price,highest price
and average price of products in that category only for those categories with more than on product.
Sort the results by the number of products in descending order*/
 SELECT CategoryID,COUNT(ProductName) AS'Nunmber of products',MIN(UnitPrice)AS'Lowest Price',
 MAX(UnitPrice)AS'Highest Price',AVG(UnitPrice)AS'Average Price'
 FROM Products
GROUP BY CategoryID

/*Write a query to display, all in capital letters, the title of courtesy,
initial, last name and title of that employee*/
SELECT UPPER(TitleOfCourtesy) as'Title of courtesy',UPPER(FirstName) AS'Name',UPPER(LastName)AS'Surname',
UPPER(Title)AS'Title'
FROM Employees
WHERE Title LIKE'%manager'

/*Display the OrderID, order date and shipment dat. Add a column on your query to indicate the difference in days
between the order date and the shipment date. Add another column to indicate the expected delivery date. The 
expected delivery date is three months after the shipment date. Ensure that the expected delivery date is the current 
date if the shipment date is not given. Eliminate all orders that made on weekends*/
SELECT OrderID,DATENAME(WEEKDAY,OrderDate)As'Order Date',ShippedDate,DATEDIFF(DAY,OrderDate,ShippedDate)AS'Waitng days',
DATEADD(MONTH,3,ShippedDate) AS'Expected delivery'
FROM Orders
WHERE CONVERT(varchar(100),OrderDate) NOT IN('Friday')
/*Display orderID and the total order amount for each order. Include the Rand sign on the total order 
amount and use a column alias. Sort the results by the total order amount in descending order.*/
SELECT OrderID, CONCAT('R',SUM(UnitPrice)) AS'Total order amount'
FROM [Order Details]
GROUP BY OrderID

/*Write T-SQL statement to copy address information from Customers table to the
addresses table created earlier in this exercise*/
INSERT INTO Addresses(Street,City,PostCode,Country,CustomerID)
SELECT ([Address]),(City),(PostalCode),(Country),(Customers.CustomerID)
FROM Customers
WHERE PostalCode IS NOT NULL--I placed the condition because the column in the recieving table has a not null constraint

/*All products that have no units in stock and no units on order must be discontinued and the 
re-order level must be set to zero. Effect this change on the database*/
UPDATE Products
SET Discontinued=0,ReorderLevel=0
WHERE UnitsInStock =0 AND UnitsOnOrder=0

/*All suppliers in the UK are increasing prices of their products by 6%. Effect this change
on the database*/

UPDATE Products
SET UnitPrice=UnitPrice*6/100+UnitPrice
FROM Products
INNER JOIN Suppliers
ON Products.SupplierID=Suppliers.SupplierID
WHERE Country='UK'

/*Display the product name,supplier name, category name and unit price for all products*/
SELECT ProductName,CompanyName,CategoryName,UnitPrice
FROM Products
INNER JOIN
Suppliers ON
Products.SupplierID=Suppliers.SupplierID
INNER JOIN Categories
ON Products.CategoryID=Categories.CategoryID

/*Display a list showing the Employees first name, last name and how many
employees reports to him/her only if the employee has more than 1 person reporting to him*/
SELECT Employees.FirstName,LastName,ReportsTo
FROM Employees
WHERE ReportsTo>1
/*Which product is the most expenisve? Show the product name and the unit price for the product only*/

SELECT DISTINCT ProductName,MAX(UnitPrice)
FROM Products
GROUP BY ProductName

/*Some customers have not made an order, list such customers)*/
SELECT CompanyName,Orders.OrderID
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID=Orders.CustomerID
WHERE Orders.OrderID IS NULL

SELECT CompanyName,Orders.OrderID
FROM Orders
RIGHT JOIN Customers
ON Customers.CustomerID=Orders.CustomerID
WHERE  Orders.OrderID IS NULL

/*Some products were sold from the standard price of the product. Display the list of order
items whose unit price is different from the the unit price */
SELECT Orders.OrderID,Products.ProductID,Products.UnitPrice AS'Standard Price',[Order Details].UnitPrice AS'Order Price '
,Products.UnitPrice-[Order Details].UnitPrice AS'Difference in prices'
FROM Products
INNER JOIN [Order Details]
ON Products.ProductID=[Order Details].ProductID
INNER JOIN Orders ON
Orders.OrderID=[Order Details].OrderID

/*Which shippers have shipped the most recent order? Show company Name ,phone and order date*/
SELECT Shippers.CompanyName,Shippers.Phone,Orders.OrderDate
FROM Shippers
INNER JOIN Orders
ON Shippers.ShipperID=Orders.ShipVia
ORDER BY Orders.OrderDate DESC

/*We need to know the number of orders made in the last 20 years for each product category.
Show the category name and the number of orders. Use a Common Table Expression */

WITH CTE_ProductCate([Category name],[Number of orders])
AS
( SELECT Categories.CategoryName,COUNT([Order Details].OrderID)
FROM Categories
INNER JOIN Products ON
Categories.CategoryID=Products.CategoryID
INNER JOIN [Order Details] ON
[Order Details].ProductID=Products.ProductID
GROUP BY Categories.CategoryName)
SELECT*
FROM CTE_ProductCate
GO
/*Display for each supplier, the supplier ID, name, country, number of products supplied, the total 
quantity of products ordered and the total value of the orders. Use a Common Table Expression*/
WITH CTESupplier([Supplier ID],[Supplier Name],[Country],[Number of Products supplied],[Total Quantity],[total Value of the product])
AS
(SELECT Suppliers.SupplierID,Suppliers.CompanyName,Suppliers.Country,COUNT(Products.ProductName)AS'Number of products supplied',[Order Details].Quantity,
[Order Details].Quantity*[Order Details].UnitPrice AS'Total value of orders'
FROM Suppliers
INNER JOIN Products
ON Suppliers.SupplierID=Products.SupplierID
INNER JOIN [Order Details]
ON Products.ProductID=[Order Details].ProductID
GROUP BY Suppliers.SupplierID,Suppliers.CompanyName,[Order Details].Quantity,
[Order Details].UnitPrice,Suppliers.Country)
SELECT*
FROM CTESupplier

/*Use the Common table expression to display the most expensive product in each category*/
WITH CTEProductCat([Category ID],[Product Name],[Price])
AS
(SELECT DISTINCT Categories.CategoryID,Products.ProductName,Products.UnitPrice
FROM Categories
INNER JOIN Products
ON Categories.CategoryID=Products.CategoryID
)
SELECT TOP(8)*
FROM CTEProductCat
ORDER BY [Price] DESC

/*Add new shippers to the Northwind Database*/
INSERT INTO Shippers(CompanyName,Phone)
VALUES
('Cargo Kings','(011) 241-5490')

/*How can you prevent users from adding duplicate shippers with the same name?*/
ALTER TABLE Shippers
ADD CONSTRAINT UC_ComapanyName UNIQUE(CompanyName)

/*11. All suppliers in UK are increasing prices of their products by 6%. 
Effect this change on the database.*/
UPDATE Products
SET Products.UnitPrice= Products.UnitPrice*6/100+ Products.UnitPrice
FROM Products
INNER JOIN Suppliers
ON Products.SupplierID=Suppliers.SupplierID
WHERE Country='UK'

/*12. Delete all employees that have never handled an order*/

DELETE Orders
WHERE EmployeeID IS NULL

/*13.Display the product name, units in stock and stock
level for all products. 
The stock levels are classified as follows. Hint: Use a CASE statement.*/
SELECT ProductName,UnitsInStock,
CASE WHEN UnitsInStock=0 THEN 'OUT OF STOCK'
	 WHEN UnitsInStock<50 THEN 'CRITICAL'
	 WHEN UnitsInStock BETWEEN 50 AND 100	  THEN 'MODERATE'
	 WHEN UnitsInStock  <100  THEN'ADEQAUTE'
END AS'STOCK LEVEL'
FROM Products


/*Create a mailing label for customer ‘EASTC’. The label must consist of the contact name, 
company name, address, city, postal code and country.*/
SELECT*FROM Customers
WHERE CustomerID='EASTC'

DECLARE @ContactName VARCHAR(100),
		@CompanyName VARCHAR(100),
		@Address VARCHAR (100),
		@City VARCHAR(100),
		@PostalCode VARCHAR(100),
		@Country VARCHAR(100)
BEGIN
SELECT @ContactName=ContactName,@CompanyName=CompanyName,@Address=Address,
@City=City,@PostalCode=PostalCode,@Country=Country
FROM Customers
WHERE CustomerID='EASTC'
		PRINT'----------------------'
		PRINT'TO: '+@ContactName
		PRINT'----------------------'
		PRINT @CompanyName
		PRINT @Address
		PRINT @City
		PRINT @PostalCode
		PRINT @Country
END

/*We need to determine how the price of a specific product compares against the overall price 
average of all products. Write a script that displays the product name, unit price and whether 
the price of the product is above average or below average. Use Perth Pasties (Product ID: 53).*/
DECLARE @ProductName VARCHAR(100),
		@UnitPrice MONEY,
		@Price MONEY
SELECT @ProductName=ProductName,@UnitPrice=UnitPrice 
FROM Products
WHERE ProductID=53
SELECT @Price= (SUM(UnitPrice))/77  FROM Products
BEGIN
IF(@UnitPrice>@Price)
BEGIN
PRINT'The price of the above product is greate than the average price'
END
ELSE
PRINT'The price of the above product is less than the average price'
END

/* The price of Northwoods Cranberry Sauce (Product ID: 8) is expected to increase by 10% every 
year for the next 5 years. Write a T-SQL script to display the expected prices over the 5-year 
period.
*/
GO
DECLARE @UnitPrice MONEY,
		@Year INT,
		@ExpectedPrice INT
SELECT @UnitPrice = Unitprice FROM Products WHERE ProductID=8
SET @Year=0
WHILE(@Year<5)
	BEGIN
	SET @UnitPrice=@UnitPrice*10/100+@UnitPrice
	SET @Year=@Year+1
	PRINT CONCAT(@Year ,':', @UnitPrice)
	END

/*Display the product name, units in stock and stock level for all products. The stock levels are 
classified as follows. Hint: Use a CASE statement*/
SELECT ProductName,UnitsInStock,Products.ReorderLevel,
CASE WHEN UnitsInStock=0 THEN 'OUT OF STOCK'
	 WHEN UnitsInStock<50 THEN 'CRITCAL'
	 WHEN UnitsInStock BETWEEN 50 AND 100 THEN'MODERATE'
	 WHEN UnitsInStock>100 THEN'ADEQUATE'
END AS'STOCK LEVEL'


FROM Products

/*The quantity for product 65 (Louisiana Fiery Hot Pepper Sauce) on order 10250 was incorrectly 
stated as 15 instead of 10. Create a transaction to correct this and increase the units in stock for 
the product by the same units. An appropriate message must be displayed to indicate whether 
the transaction is successful or not.*/
BEGIN TRY
BEGIN TRANSACTION Trans1
UPDATE [Order Details]
SET Quantity=10
WHERE ProductID=65
COMMIT TRANSACTION
PRINT 'The transaction was successfull'
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
PRINT'TRANSACTION FAILED WITH THE FOLLOWING ERROR'
PRINT ERROR_MESSAGE()
END CATCH

/* Modify your solution for Question 1 to print mailing labels for all the customers. Hint: Use a 
cursor*/
DECLARE @ContactName  VARCHAR(100),
		@CompanyName VARCHAR(100),
		@Address     VARCHAR(100),
		@City        VARCHAR(100),
		@PostalCode  VARCHAR(100),
		@Country     VARCHAR(100)
DECLARE Cur1 CURSOR FOR
SELECT ContactName,CompanyName,Address,City,PostalCode,Country
FROM Customers
OPEN Cur1
FETCH NEXT FROM Cur1 INTO @ContactName ,@CompanyName,@Address,@City,@PostalCode,@Country  
WHILE(@@FETCH_STATUS=0)
BEGIN
FETCH NEXT FROM Cur1 INTO @ContactName ,@CompanyName,@Address,@City,@PostalCode,@Country  
PRINT'----------------------'
		PRINT'TO: '+@ContactName
		PRINT'----------------------'
		PRINT @CompanyName
		PRINT @Address
		PRINT @City
		PRINT @PostalCode
		PRINT @Country
END
CLOSE Cur1
DEALLOCATE Cur1

/*Modify your solution for Question 2 such that the user will provide any product ID. (Hint: 
Convert it to a stored procedure*/
CREATE PROCEDURE Pro1 @Input AS INT
AS
DECLARE  
		@Price MONEY,
		@AvgPrice MONEY
SELECT @Input=ProductID FROM Products WHERE @Input IN(ProductID)
SELECT @Price =UnitPrice FROM Products WHERE ProductID=@Input
SELECT @AvgPrice=SUM(UnitPrice)/77 FROM Products
IF(@Price>@AvgPrice)
BEGIN
PRINT'The price of the product number '+CAST(@Input as VARCHAR(100))+'is greater than the average price'
END
ELSE
BEGIN
PRINT'The price of the product number '+CAST(@Input AS VARCHAR(100))+'is less than the average price'
END

EXEC Pro1 '1'
/*. Create a stored procedure spSearchSupplier to search for a supplier by matching any part of the 
company name. The stored procedure must show the full company name, contact name and 
phone number for all matching suppliers*/
 CREATE PROCEDURE spSearchSupplier @Search AS VARCHAR(100)
 AS
 
 
 BEGIN
 SELECT CompanyName,ContactName,Phone
 FROM Suppliers
 WHERE CompanyName lIKE'%'+@Search+'%'
 END


 EXEC spSearchSupplier 'Exotic Liquids'
/*Create a stored procedure spPriceIncrease that accepts a product category ID and a percentage 
increase. The stored procedure checks whether the category ID is valid and whether the increase 
is between 0 and 100, and then increases the prices of products in the given category by the 
percentage increase given. An appropriate message must be displayed if one of the parameters 
given is invalid.*/



CREATE PROCEDURE spPriceIncrease @CatID VARCHAR(100),@Percentage INT
AS
DECLARE @Price MONEY,
		@True VARCHAR
SELECT @Price=UnitPrice FROM Products
SELECT CategoryName FROM Categories WHERE CategoryID=@CatID
SET @True ='Transaction completed'
BEGIN
IF(@CatID BETWEEN 1 AND 8 AND @Percentage BETWEEN 0 AND 100)
BEGIN
RETURN @True
END
ELSE
BEGIN
RETURN 'Invalid selection'
END
END
EXEC spPriceIncrease 2,4
DROP PROCEDURE spPriceIncrease

/*Create a function fnVAT that calculates the value added tax (VAT) depending on the category of 
a product. Category 5 products (Grains/Cereals) are zero rated, i.e. they are not charged VAT. 
Category 4 and 7 incur a VAT rate of 10%. Category 2, 3 and 8 incur a VAT rate of 12% and the 
rest of the categories have a rate of 15%. 
Use your function to display the product name, unit price, VAT and selling price after the VAT 
has been added.*/
GO
CREATE FUNCTION dbo.fnVAT(@CatID VARCHAR(100)
RETURNS AS

BEGIN

DECLARE @Price INT,
@CatID VARCHAR(100),
@VAT INT,
@Prod VARCHAR(100)
SELECT @Price=UnitPrice FROM Products
SELECT @CatID=Products.CategoryID FROM Products
SELECT @Prod=ProductName FROM Products WHERE CategoryID=@CatID
IF(@CatID=5)
BEGIN
SET @VAT=0
SET @Price=@Price*@VAT+@Price
RETURN @Prod+@Price+@VAT+@Price
END
ELSE IF(@CatID=4 OR @CatID=7)
BEGIN
SET @VAT=10/100
SET @Price=@Price*@VAT+@Price
PRINT @Prod+@Price+@VAT+@Price
END
ELSE IF(@CatID=2 OR @CatID=3 OR @CatID=8)
BEGIN
SET @VAT=12/100
SET  @Price=@Price*@VAT+@Price
PRINT @Prod+@Price+@VAT+@Price
END
ELSE
BEGIN
SET @VAT=12/100
SET  @Price=@Price*@VAT+@Price
PRINT @Prod+@Price+@VAT+@Price
END
END

/*Create a function PCODE that accepts a product ID and creates a product short code by joining 
the first 4 letters of the product name and the two-digit product ID all in uppercase. For 
example, the short code for product 2 will be ‘CHAN02’. Demonstrate how the function works by 
displaying the product ID, product name and short code for all products. Hint: Use a SELECT 
statement in the UDF to get the product name*/

CREATE PROCEDURE PCODE @ProductID INT
AS
DECLARE @ProductName






 SELECT*
 FROM Suppliers

CREATE PROCEDURE One
AS 
SELECT*
FROM Customers

EXEC One