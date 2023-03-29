CREATE FUNCTION dbo.PCODE
(@ProdID VARCHAR(100))
RETURNS VARCHAR(100) AS
BEGIN
DECLARE
@ProdNameID VARCHAR(100),
@ProdName VARCHAR(100)
SELECT @ProdName= UPPER(SUBSTRING((ProductName),1,4))
				FROM Products
SELECT @ProdID = Products.ProductID
				FROM Products
				WHERE @ProdID IN(ProductID)
SET @ProdNameID=CONCAT(@ProdName,@ProdID)

RETURN @ProdNameID
END

SELECT dbo.PCODE(4)
DROP FUNCTION dbo.PCODE
;GO
/*Views*/
CREATE VIEW vEmpSummary(Products)
AS
SELECT Products.ProductName,Suppliers.CompanyName,Categories.CategoryName,
		UnitPrice,UnitsInStock
		FROM Products
INNER JOIN Suppliers ON
Products.SupplierID=Suppliers.SupplierID
INNER JOIN Categories ON
Products.CategoryID=Categories.CategoryID

SELECT*
FROM vEmpSummary

CREATE VIEW vEmpSummary
AS
SELECT COUNT(DISTINCT Orders.OrderID) AS'Number of Orders',Employees.EmployeeID,Employees.TitleOfCourtesy,Employees.FirstName,
Employees.LastName,Employees.Title,Employees.BirthDate,DATEDIFF(YEAR,2023,Employees.BirthDate) AS'Age',
DATEDIFF(YEAR,GETDATE(),Employees.HireDate)'Years in service',SUM([Order Details].UnitPrice*[Order Details].Quantity)'Total value of orders'
FROM Employees
INNER JOIN Orders ON
Employees.EmployeeID=Orders.EmployeeID
INNER JOIN [Order Details] ON
Orders.OrderID=[Order Details].OrderID
GROUP BY Employees.EmployeeID,Employees.TitleOfCourtesy,Employees.FirstName,
Employees.LastName,Employees.Title,Employees.BirthDate,
Employees.HireDate

SELECT*
FROM vEmpSummary

DROP VIEW vEmpSummary

CREATE TRIGGER NoDeletion
ON Products
INSTEAD OF DELETE
AS
BEGIN 
SELECT Categories.CategoryName
FROM Categories
END

DROP TRIGGER NoDeletion

CREATE TABLE [Audit]
(LogID INT IDENTITY(111111,1) PRIMARY KEY,
Enity VARCHAR(15) NOT NULL,
EntityID VARCHAR(5) NOT NULL,
LogAction CHAR(1) NOT NULL,
OldValue VARCHAR(50),
NewValue VARCHAR(50),
Details VARCHAR(100),
LogDate SMALLDATETIME NOT NULL DEFAULT(GETDATE()),
UserName VARCHAR(50) DEFAULT(SYSTEM_USER))



/*Triggers*/
CREATE TRIGGER UPDATES
ON DummyTable
AFTER UPDATE
AS
BEGIN
DECLARE @ShippersID INT,
		@Action VARCHAR(50)
SELECT @ShippersID=inserted.ShipperID
FROM inserted

IF UPDATE(ShipperID)
BEGIN
SET @Action='CustomerID Updated'
END
IF UPDATE(CompanyName)
BEGIN
SET @Action='CompanyName is updated'
END
IF UPDATE(Phone)
BEGIN
SET @Action='Phone Updated'
END

INSERT INTO UpdatesLog
VALUES
(@ShippersID,@Action)
END


DROP TABLE UpdatesLog

DROP TRIGGER UPDATES

CREATE TABLE UpdatesLog
(ShipID VARCHAR(50),
Status VARCHAR(50))

 UPDATE DummyTable
 SET Phone ='00000000000'
 WHERE CompanyName ='Cargo Kings'
SELECT*

FROM UpdatesLog