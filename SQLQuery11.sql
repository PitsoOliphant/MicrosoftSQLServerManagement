CREATE PROCEDURE spPriceIncrease
	@CatID INT,
	@PriceIncrease INT
AS
IF( @PriceIncrease BETWEEN 0 AND 100 AND @CatID=(SELECT Products.CategoryID FROM Products WHERE Products.CategoryID LIKE'%'+@CatID+'%'))
BEGIN
	SELECT UnitPrice*@PriceIncrease+UnitPrice
	FROM Products
END

DROP PROCEDURE spPriceIncrease
GO
CREATE PROCEDURE Price
	@CatID INT
	
	
AS
	SET @CatID=(SELECT Products.CategoryID FROM Products WHERE Products.CategoryID lIKE CONVERT(INT,'%')+@CatID+ CONVERT(INT,'%')
	
IF  ( @CatID=@CatID) 
BEGIN
PRINT 'Hello'
END
ELSE
	BEGIN
PRINT'ERROR'
	END


EXECUTE Price 5
DROP PROCEDURE Price






