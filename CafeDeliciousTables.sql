USE CafeDelicious
GO 
CREATE TABLE City
(CityID INT IDENTITY(1,1),
CityName VARCHAR(20) DEFAULT'E.g Pretoria' NOT NULL)

CREATE TABLE Country
(CountryID INT IDENTITY(1,1) PRIMARY KEY,
CountryName VARCHAR(20) DEFAULT 'Chosse a country.E.g South Africa' CHECK([CountryName] IN('South Africa','Argentina','Spain','Zimbabwe'))NOT NULL)

CREATE TABLE Suburb
(SurburID INT IDENTITY(1,1) PRIMARY KEY,
SuburbName VARCHAR(20) NOT NULL DEFAULT'E.g SunnySide...',
PostalCode VARCHAR (4) UNIQUE CHECK(PostalCode BETWEEN 0 AND 99) NOT NULL,
SuburbCityIdFK INT  REFERENCES Suburb(SurburID),
SuburbCountryIdFK INT REFERENCES Country(CountryID))

CREATE TABLE WTYpe
(WTYpeID INT IDENTITY(1,1) PRIMARY KEY,
WTypeName VARCHAR(20) NOT NULL DEFAULT'Enter First name',
WTypeSalary MONEY NOT NULL CHECK(WTypeSalary>0))

CREATE TABLE Waiter
(WaiterID INT IDENTITY(1,1) PRIMARY KEY,
WaiterFirstName VARCHAR(15) NOT NULL DEFAULT 'Enter first name',
WaiterSurname VARCHAR(15) NOT NULL DEFAULT'Enter surname',
WaiterSurburbIdFK INT  REFERENCES Suburb(SurburID),
WaiterTypeIdFK INT  REFERENCES WTYpe(WTypeID),
WaiterDateHired DATE NOT NULL CHECK(WaiterDateHired<GETDATE()),
WaiterPhoneNumber VARCHAR(10) UNIQUE NOT NULL DEFAULT'Enter phone numbers',
WaiterEmail VARCHAR(50) UNIQUE NOT NULL DEFAULT 'Enter Email address',
WaiterBirthDay DATE NOT NULL DEFAULT 'Enter birth date')

CREATE TABLE Work
(WorkWaiterIdFK INT REFERENCES Waiter(WaiterID),
WorkDate DATE,
WorkStartHour TIME DEFAULT 'Enter starting working hours',
WorkEndHour TIME DEFAULT 'Enter End Working time')

CREATE TABLE Bill
(BillID INT IDENTITY(1,1) PRIMARY KEY,
BillDate DATE NOT NULL DEFAULT(GETDATE()),
BillTableNumber INT UNIQUE NOT NULL,
BillWaiterIdFK INT REFERENCES Waiter(WaiterID))

CREATE TABLE Dish
(DishID INT IDENTITY(1,10) PRIMARY KEY,
DishName VARCHAR(15) UNIQUE NOT NULL DEFAULT'Enter name of dish',
DishPrice MONEY NOT NULL DEFAULT'Enter price of dish')

CREATE TABLE SubSeafood
(SubSeafoodID INT IDENTITY(1,1) PRIMARY KEY,
SubSeafoodDishIdFK INT REFERENCES Dish(DishID),
SubFoodBillIdFK INT REFERENCES Bill(BillID))

CREATE TABLE SubFluid
(SubFluidID INT IDENTITY(1,1) PRIMARY KEY,
SubFluidDrinkIdFK INT REFERENCES Bill(BillID),
SubFluidQuantity INT NOT NULL,
SubFluidBillFK INT REFERENCES Bill (BillID))

CREATE TABLE DishCommission
(DishComID INT IDENTITY(1,1) PRIMARY KEY,
DishComWaiterIdFK INT REFERENCES Waiter (WaiterID),
DishComQauntitySold INT NOT NULL,
)

CREATE TABLE IDType
(DTypeId INT IDENTITY(1,1) PRIMARY KEY,
DTypeName VARCHAR(25) NOT NULL)

CREATE TABLE Drink
(DrinkID INT IDENTITY(1,1) PRIMARY KEY,
DrinkName VARCHAR(25) UNIQUE NOT NULL DEFAULT 'Enter name of drink',
DrinkPrice MONEY NOT NULL DEFAULT 'Enter price of drink',
DrinkTypeIdFK INT REFERENCES IDType(DTypeId),
DrinkCommission MONEY NOT NULL)


CREATE TABLE DrinkComission
(DrinkComID INT IDENTITY(1,1) PRIMARY KEY,
DrinkComDrinkIdFK INT REFERENCES Drink(DrinkID),
DrinkComWaiterIdFK INT REFERENCES Waiter(WaiterID),
DrinkComQuantitySold INT NOT NULL,
DrinkComPaidOut MONEY NOT NULL)

CREATE TABLE Measurement
(MeasureID INT IDENTITY(1,1) PRIMARY KEY,
MeasureName VARCHAR(25) NOT NULL)

CREATE TABLE Product 
(ProductID INT IDENTITY(1,1) PRIMARY KEY,
ProductName VARCHAR(25) NOT NULL DEFAULT 'UNDEFINED',
ProductMeasuremeantIdFK INT REFERENCES Measurement(MeasureID),
ProductInStock BIT NOT NULL,
ProductReOrderLever INT CHECK(ProductReOrderLever BETWEEN 1 AND 3))

CREATE TABLE Ingredient
(IngredientId INT IDENTITY(1,1) PRIMARY KEY,
IngredientDishIdFK INT REFERENCES Dish(DishID),
IngredientProductIdFK INT REFERENCES Product(ProductID))