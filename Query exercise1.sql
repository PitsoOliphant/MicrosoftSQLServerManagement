/*Adding a secondary filegroup to the Northwind Database*/
ALTER DATABASE Northwind
ADD FILEGROUP Secondary
ALTER DATABASE Northwind
ADD FILE
(NAME=nwdata2,
FILENAME='C:\SQLDATA\Northwind\nwdata2.ndf',
SIZE=20MB,
MAXSIZE=1GB,
FILEGROWTH=5%)

/*Creating a table called addresses*/
--Add a new table to the Northwind database
CREATE TABLE Addresses
(AddressID INT IDENTITY(201,1) PRIMARY KEY,
CustomerID VARCHAR(5) NULL REFERENCES Customers(CustomerID),
Street VARCHAR(25) NOT NULL,
City VARCHAR(25) NOT NULL,
PostalCode VARCHAR(30) NOT NULL,
Country  VARCHAR(50) NOT NULL)

/*Altering the Northwind Database tables*/
--Ensure that CategoryName does not have duplicates
ALTER TABLE Categories
ADD CONSTRAINT UQ_CategoryName UNIQUE(CategoryName)

--Ensure that the current date is given if the OrderDate is left blank
ALTER TABLE Orders
ADD CONSTRAINT DF_OrderDate DEFAULT(GETDATE()) FOR OrderDate

--Ensure that the shipped date cannot be earlier than the order date
ALTER TABLE Orders
ADD CONSTRAINT CK_ShippedDate CHECK(ShippedDate>OrderDate)

CREATE NONCLUSTERED INDEX IN_Country
ON Addresses(Country)

--Creating a composite nonclustered index
CREATE NONCLUSTERED INDEX IN_Address
ON Addresses(City,PostalCode)

--First three employees to get hired
SELECT TOP(3) FirstName,LastName,HireDate
FROM Employees

--Retreive non repeating values from country
SELECT DISTINCT Country
FROM Customers

--Display a list of suppliers that are not form the UK,USA,Germany and France.Show the company name with the column heading"Supplier Name"
SELECT CompanyName AS 'Supplier Name', Country
FROM Suppliers
WHERE NOT (Country='UK' OR Country='France' OR Country='USA')

--Show the product name and the unit price of all the products with range of 100 to 150, sorted in descending order of price
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 100 AND 150
ORDER BY UnitPrice DESC

--Display the column company name as Customer Name, contactName, ContacTitle, Phone where all the contacts are managers
SELECT CompanyName AS 'Customer Name',ContactName,ContactTitle, Phone
FROM Customers
WHERE ContactTitle  LIKE '%manager%'

--Show the country and the  number of customers 
SELECT COUNT (CompanyName) AS'Number of Customers per Country', Country
FROM Customers
GROUP BY Country

--Retrieve the Category ID, Number of products, the lowest price, highest price and average price of products in that
--category only for those categories with more than 1 products. Sort the results by the number of products in descending order
SELECT  CategoryID,COUNT(QuantityPerUnit) AS 'Number of products',MAX(UnitPrice) AS'Highest Price',Min(UnitPrice) AS'Lowest Price',
AVG(UnitPrice) AS'Average Price'
FROM Products
GROUP BY CategoryID

--Make a query that displays, all in capital letters, the title of courtesy, initial, last name and title of the employee
SELECT UPPER (FirstName) AS 'First Name',UPPER(LastName) AS'Last Name',UPPER(Title) AS 'Title',SUBSTRING(FirstName,1,1) AS 'Initials'
FROM Employees
WHERE  Title LIKE '%Manager%'

/*Display the order id, order date, and shipment date. Add column on your query to indicate the difference in days
between the order data and the shipment date. Add another column to show the expected delivery date. The expected delivery data should be 
three months after the shipment date. Ensure the expected delivery date is the current if the shipment date is not given*/
SELECT OrderId, OrderDate,DATEDIFF(DAY,OrderDate,ShippedDate) AS 'Difference between oreder date and shipped date',
DATEADD(MONTH,3,ShippedDate) AS'expected delivery' ,ISNULL(ShippedDate,GETDATE()), DATENAME(WEEKDAY,OrderDate) AS'Days of the week'
FROM Orders

/*Display the order id and the total amount for each order. Include the Rand sign on the total order amount and use a column alias. Sort 
the results by the total order amount in descending order*/
SELECT OrderID, CONCAT('R',UnitPrice*Quantity) AS 'Total order amount'
FROM [Order Details]
ORDER BY [Total order amount] DESC

/*Write a T-SQL statement to copy address information from Customers table in the Addresses table created earlier*/

INSERT INTO Addresses(CustomerID)
SELECT CustomerID
FROM Customers

/*SELECT *
FROM Customers

SELECT*
FROM Addresses

ALTER TABLE Addresses
ALTER COLUMN Country NVARCHAR(50) NULL

DROP INDEX[IN_Address]
ON Addresses*/

/*All products that have no units in stock and no units on order must be discontinued and the 
re-order level must be set to zero*/

UPDATE Products
SET Discontinued =0
WHERE UnitsInStock=0 AND UnitsOnOrder=0

SELECT *
FROM Products

