
/*Inner Join*/
SELECT CompanyName,ProductName,UnitPrice, Categories.CategoryName
FROM Suppliers
INNER JOIN Products
ON Suppliers.SupplierID=Products.ProductID
INNER JOIN Categories
ON Products.ProductID=Categories.CategoryID

/*CommonTableExpression*/
WITH CTE_Results([Product name],[supplier name],[ category name],Price)
AS
(SELECT ProductName,Suppliers.CompanyName,Categories.CategoryName,UnitPrice
FROM Products
LEFT JOIN Suppliers
ON Products.ProductID=Suppliers.SupplierID
LEFT JOIN Categories
ON Products.ProductID=Categories.CategoryID)
SELECT *
FROM CTE_Results;

SELECT FirstName,LastName
FROM Employees
WHERE ReportsTo>1

SELECT  (UnitPrice) ,ProductName
FROM Products
ORDER BY UnitPrice DESC

SELECT Customers.CompanyName
FROM Customers
INNER JOIN Addresses
ON Customers.AddressID=Addresses.AddressID
WHERE Addresses.CustomerID IS NULL;

WITH CTE_CustomerDetails([C:ID],[Customer name])
AS
(SELECT Customers.CustomerID, Customers.CompanyName
FROM Customers
INNER JOIN Addresses
ON Customers.AddressID=Addresses.AddressID
WHERE Addresses.CustomerID IS NULL
)


SELECT*
FROM CTE_CustomerDetails

SELECT OrderID,Products.ProductName,Products.UnitPrice,[Order Details].UnitPrice
,CONCAT('R',Products.UnitPrice-[Order Details].UnitPrice) AS 'Price difference'
FROM [Order Details]
INNER JOIN Products
ON [Order Details].ProductID=Products.ProductID

SELECT CompanyName,Phone, MAX(Orders.OrderDate) AS 'Date Delivery'
FROM Shippers
INNER JOIN Orders
ON Shippers.ShipperID=Orders.ShipVia
GROUP BY CompanyName,Phone;

WITH CTE_ProductCategory([Category Name],[Number of Orders],[Order date])
AS
(SELECT Categories.CategoryName,[Order Details].Quantity, DATEPART(YEAR,Orders.OrderDate)
FROM Products
INNER JOIN Categories
ON Products.CategoryID=Categories.CategoryID
INNER JOIN [Order Details]
ON Products.ProductID=[Order Details].ProductID
INNER JOIN Orders ON 
[Order Details].OrderID=Orders.OrderID
WHERE OrderDate>20)
SELECT*
FROM CTE_ProductCategory;

WITH CTE_Supplies([Supplier ID],[Name of supplier],[Country],[number of product supplied],
[total quantity of the products],[total value])
AS
(SELECT Suppliers.SupplierID,Suppliers.CompanyName,Suppliers.Country,[Order Details].Quantity,
(Products.UnitsOnOrder+Products.ReorderLevel),Products.UnitPrice*[Order Details].Quantity
FROM Products
INNER JOIN Suppliers
ON Products.SupplierID=Suppliers.SupplierID
INNER JOIN [Order Details]
ON Products.ProductID=[Order Details].ProductID)
SELECT*
FROM CTE_Supplies

SELECT Categories.CategoryName,[Order Details].Quantity
FROM Products
INNER JOIN Categories
ON Products.CategoryID=Categories.CategoryID
INNER JOIN [Order Details]
ON Products.ProductID=[Order Details].ProductID

WITH CTE_ExpensiveProductPerCategory([Catergory ID],[Product Name],[Unit Price])
AS
(SELECT Categories.CategoryID,Products.ProductName,(Products.UnitPrice)
FROM Categories
INNER JOIN Products
ON Categories.CategoryID=Products.CategoryID

)
SELECT*
FROM CTE_ExpensiveProductPerCategory

INSERT INTO Shippers(CompanyName,Phone)
VALUES
('Cargo Kings','(011) 241-5490')

ALTER TABLE Shippers
ADD CONSTRAINT UC_CompanyName UNIQUE(CompanyName)

SELECT Products.ProductName,Suppliers.CompanyName,Suppliers.SupplierID
FROM Products
INNER JOIN Suppliers ON
Products.SupplierID=Suppliers.SupplierID
WHERE Country='UK'

UPDATE Products
SET UnitPrice=(UnitPrice*6/100)
WHERE SupplierID IN(1,8)

DELETE Orders
WHERE EmployeeID IS NULL

SELECT ProductName,Products.UnitsInStock,
	CASE WHEN UnitsInStock=0 THEN 'Out Of Stock'
	WHEN UnitsInStock <50 THEN 'CRITICAL'
	WHEN UnitsInStock>50 AND UnitsInStock<100 THEN 'MODERATE'
	ELSE 'ADEQUATE'
	END AS 'Stock Level'
FROM Products

SELECT FirstName
FROM Employees
SELECT*
FROM Orders 
SELECT Employees.EmployeeID
FROM Employees

SELECT Categories.CategoryID,ProductName,UnitPrice
FROM Products
INNER JOIN Categories
ON Products.CategoryID=Categories.CategoryID
ORDER BY UnitPrice DESC

/*Sub-Queries*/
SELECT Categories.CategoryID,Categories.CategoryName
FROM Categories
WHERE Categories.CategoryID IN 
(SELECT Products.ProductID
FROM Products
INNER JOIN Suppliers
ON Products.ProductID=Suppliers.SupplierID)


FROM [Order Details]  

SELECT Categories.CategoryID,ProductName,UnitPrice
FROM Products
INNER JOIN Categories
ON Products.CategoryID=Categories.CategoryID
ORDER BY UnitPrice DESC