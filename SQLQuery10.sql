DECLARE @AveragePrice MONEY,
		@ProdPrice MONEY


SET @AveragePrice=(SELECT SUM(UnitPrice)/77 FROM Products)
SET @ProdPrice=(SELECT UnitPrice 
				FROM Products
				WHERE ProductID=53)


IF(@AveragePrice>@ProdPrice)
	BEGIN
		PRINT 'Average Price is greater'
	END
ELSE IF(@AveragePrice<@ProdPrice)
	BEGIN
		PRINT'Average Price is less'
	END
ELSE
	BEGIN
		PRINT'Average Price is equal to the overall price'
	END


DECLARE @UnitPrice MONEY,
		@Years INT,
		@Year VARCHAR 
		

SET @UnitPrice=(SELECT UnitPrice  FROM Products WHERE ProductID=8)
SET @Years=1
SET @Year='Year'


WHILE (@Years<=5)
	BEGIN
		SET @UnitPrice=@UnitPrice*10/100+@UnitPrice
		SET @Years=@Years+1
		
		PRINT CAST(@Year AS INT)+''+CAST(@Years AS INT)+''+CAST(@UnitPrice AS INT)
	END


SELECT ProductName,Products.UnitsInStock,
CASE
	WHEN UnitsInStock=0 THEN 'Out of stock'
	WHEN UnitsInStock<50 THEN 'CRITICAL'
	WHEN UnitsInStock <=100 THEN' MODERATE'
	WHEN UnitsInStock>100 THEN 'ADEQUATE'
	END AS'Stokc Level'
FROM Products

BEGIN TRY
	BEGIN TRANSACTION
	UPDATE [Order Details]
SET Quantity=10
WHERE OrderID=10250
	COMMIT TRANSACTION
	PRINT'You have successfully updated!!'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	PRINT'Update failed'
	PRINT ERROR_MESSAGE()
END CATCH
;


CREATE PROCEDURE Pro1
AS
BEGIN
DECLARE @AveragePrice MONEY,
		@ProdPrice MONEY,
		@ProductID INT

SET @ProductID=(SELECT ProductID FROM Products)
SET @AveragePrice=(SELECT SUM(UnitPrice)/77 FROM Products)
SET @ProdPrice=(SELECT UnitPrice 
				FROM Products
				 )
IF(@AveragePrice>@ProdPrice)
	BEGIN
		PRINT 'Average Price is greater'
	END
ELSE IF(@AveragePrice<@ProdPrice)
	BEGIN
		PRINT'Average Price is less'
	END
ELSE
	BEGIN
		PRINT'Average Price is equal to the overall price'
	END
END

EXECUTE Pro1

DROP PROCEDURE Pro1
CREATE PROCEDURE spSearch
	 @Searcheard VARCHAR(50)
AS 
	BEGIN
		SELECT CompanyName,ContactName,Phone
		FROM Suppliers
		WHERE CompanyName LIKE '%'+@Searcheard%+'%'
	END
GO
EXECUTE spSearch ''


SELECT*
FROM Products
;
GO


CREATE PROCEDURE SpPriceIncrease
	@CatID VARCHAR,
	@Percentage INT
AS
	BEGIN
		
IF(@Percentage BETWEEN 0 AND 100 AND @CatID IN (SELECT CategoryID FROM Products WHERE CategoryID LIKE'%'+@CatID+'%'))
BEGIN
SELECT UnitPrice*@Percentage+UnitPrice
FROM Products
WHERE CategoryID=@CatID
		
		PRINT'Transaction was executed'
END		 


ELSE

PRINT'Transaction failed'
END

EXECUTE  SpPriceIncrease 2,5
DROP PROCEDURE SpPriceIncreas

CREA