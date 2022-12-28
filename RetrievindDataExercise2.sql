USE SoccerLeague
GO
CREATE TABLE PlayingPosition
(PlayingPositionID INT IDENTITY(1,1) PRIMARY KEY,
Description VARCHAR(25))
--
CREATE TABLE Team
(TeamID INT IDENTITY(1,1) PRIMARY KEY,
TeamName NVARCHAR(30) NOT NULL,
LeagueGoals INT NOT NULL,
LeaguePoints INT NOT NULL)
--
CREATE TABLE Player
(PlayerID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(25) NOT NULL,
LastName VARCHAR(25) NOT NULL,
PlayingPositionID INT REFERENCES PlayingPosition(PlayingPositionID) NOT NULL,
TeamID INT REFERENCES Team(TeamID) NOT  NULL,
JerseyNumber INT NOT NULL,
LeagueGoals INT NOT NULL,
DateOfBirt DATE NOT NULL)
--
CREATE TABLE StadiumClass
(ClassID INT IDENTITY(1,1) PRIMARY KEY,
Description VARCHAR(30) NOT NULL)
--
CREATE TABLE Stadium
(StadiumID INT IDENTITY(1,1) PRIMARY KEY,
StadiumName NVARCHAR(30) NOT NULL,
Address VARCHAR(30),
MAXCapacity INT NOT NULL,
ClassID INT REFERENCES StadiumClass(ClassID) NOT NULL)
--
CREATE TABLE Referee
(RefereeID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(25) NOT NULL,
LastName VARCHAR(25) NOT NULL,
DateOfBirth DATE NOT NULL)
--
CREATE TABLE Match
(MatchID INT IDENTITY(1,1) PRIMARY KEY,
HomeTeamID INT REFERENCES Team(TeamID) NOT NULL,
HomeGoals INT REFERENCES Team(TeamID) NOT NULL,
AwayTeamID  INT REFERENCES Team(TeamID) NOT NULL,
AwayGoals INT,
PrimaryReferee INT REFERENCES Referee(RefereeID) NOT NULL,
SecondaryReferee INT REFERENCES Referee(RefereeID),
StadiumID INT REFERENCES Stadium(StadiumID)NOT NULL,
MatchDate DATE NOT NULL)

GO
INSERT INTO PlayingPosition(Description)
VALUES
('GoalKeeper'),('Centre-Back'),('Sweeper'),
('Wing-Back'),('Defensive Midfielder'),('Central Midfielder'),
('Winger'),('Attacking Midfielder'),('Forward'),('Striker')

INSERT INTO Team(TeamName,LeagueGoals,LeaguePoints)
VALUES
('Mamelodi Sundowns',24,28),
('Richards Bay',11,23),
('SuperSports United',17,21),
('Kaizer Chiefs',16,21),
('Orlando Priates',9,19),
('Chippa United FC',16,18),
('Amazulu FC', 11,17),
('Golden Arrows',15,16),
('Royal AM',14,16),
('Stellenbosch',14,14)

INSERT INTO Player(FirstName,LastName,PlayingPositionID,TeamID,JerseyNumber,LeagueGoals,DateOfBirt)
VALUES
('Aliza', 'Klimowski',3,5,3,11,'12/3/1998'),
('Micheil','Patten',2,7,2,54,'8/5/1990'),
('Lydie','Raiden',3,9,7,75,'2/8/1994'),
('Minny','Kitchen',10,9,7,36,'1/30/1978'),
('Minta','Denison',8,4,9,47,'5/1/1993'),
('Loni','Attewell',10,1,10,80,'2/25/1979'),
('Jessalin','Delatour',6,4,3,70,'6/4/1995'),
('Myrah','Blann',2,9,3,26,'9/24/1980'),
('Eal','Eagell',2,10,9,55,'8/5/1983'),
('Wait','Pluck',10,5,2,90,'12/4/1978'),
('Savin','Venturoli',2,2,5,25,'8/17/1998'),
('Terrijo','Whitaw',2,10,5,61,'8/14/1988'),
('Teado','Oki',10,3,3,5,'1/23/1985'),
('Stacy','Pinwill',3,7,2,12,'3/26/1988'),
('Standfield','Lemmon',6,8,4,91,'3/15/1992'),
('Kayla','Semsworth',3,5,6,68,'5/31/1975'),
('Jehanna','Mergach',7,5,1,24,'10/30/1977'),
('Faye','Thayee',2,3,2,86,'5/16/1988'),
('Sebastiano','Eley',5,1,2,96,'7/31/1982'),
('Briggs','Goodfellow',6,9,5,19,'10/1/1993'),
('Weider','Matsukiewcz',5,6,8,28,'4/13/1997'),
('Lorenzo','Bortoluzzi',3,2,10,92,'10/22/1989')

INSERT INTO Referee(FirstName,LastName,DateOfBirth)
VALUES
('Con','Pigon','3/25/1979'),
('Caz','Hoolighan','9/18/1975'),
('Helli','Crutchley','3/8/1992'),
('Teri','Bagnall','6/12/1996'),
('Whitman','Poles','10/21/1995'),
('Judye','Brignall','2/21/1995'),
('Caitlin','Shone','9/27/1977'),
('Meris','Boecke','2/10/1994'),
('Kelly','Mation','2/8/1995'),
('Cad','Pownall','7/15/1973')

INSERT INTO StadiumClass(Description)
VALUES
('Designed as the main association football stadium for the World Cup, it is the largerst stadium in Africa.
The stadium is known also as the "The Calabash" as it resembles the African Pot'),
('League, provincial, international football games have all been played at the stadium, and has seen teams such as 
Brazil, Manchester United, and Arsenal play. The stadium is a center piece for sports'),
('A multi-purpose stadium in Mabopane. It was mostly used for soccer matches '),
('A multi-purpose stadium in Mafikeng. It currently used for soccer matches. Was designed and built by an Israeli firm'),
('The stadium was built for the 2010 FIFA World Cup, during the planning stages it was known as Green Point Stadium
,which is the stadium that is adjecent to it. It is the home ground of the Premier Soccer League'),
('Football stadium in Durban in the KwaZulu-Natal, named after the General Secretary of the South African Communist
Party it is a multi-purpose stadium'),
('Stadium located in Kings Park Sporting Precinct, Durban. It is the home ground of the Sharks. The stadium is also
used Durban-based Premier Soccer League clubs and large finals')

INSERT INTO Stadium(StadiumName,Address,MAXCapacity,ClassID)
VALUES
('FNB Stadium','Stadium Avenue, Nasrec, Johannesburg, South Africa',94736,1),
('Ellis Park Stadium','47 N.Park Lane Doornfontein, Johannesburg, Gauteng Province,2028,South Africa',62567,2),
('Odi Stadium', 'Mabopane, Pretoria , Gauteng Province,South Africa',60000,3),
('Mmabatho Stadium','Mafikeng, North West Province, South Africa',60000,4),
('Cape Town Stadium','Fritz Sonnenburg Road, Green Point, Cape Town, South Africa',55000,5),
('Moses Mabhida Stadium','44 Walter Gilbert Raod, Stamford Hill, Durban, South Africa',55500,6),
('Kings Park Stadium','Jacko Jackson Drive, Durban, South Africa',54000,7)

INSERT INTO Match(HomeTeamID,HomeGoals,AwayTeamID,AwayGoals,PrimaryReferee,SecondaryReferee,StadiumID,MatchDate)
VALUES
(6,6,9,55,8,1,2,'7/8/2017'),
(9,2,2,72,3,5,3,'3/15/1975'),
(9,4,9,95,7,2,6,'6/8/2013'),
(2,9,10,45,1,9,6,'1/8/1979'),
(7,1,5,86,8,5,3,'9/3/2011'),
(10,8,7,35,6,3,2,'12/24/2002'),
(1,6,8,93,7,10,2,'3/18/2013'),
(2,3,2,78,3,5,2,'4/22/1976'),
(1,5,3,87,1,4,3,'11/8/2003'),
(2,3,2,78,3,5,2,'5/1/2020'),
(2,2,8,53,2,8,7,'10/10/1980'),
(6,7,7,35,5,9,3,'8/15/1991'),
(4,2,10,18,2,7,4,'2/22/2000'),
(7,8,4,97,9,8,5,'1/27/1999'),
(10,6,10,68,10,2,3,'1/5/1982')

/*Display the number of players per TeamID */
SELECT TeamID,COUNT(PlayerID) AS'Number of Players'
FROM Player
GROUP BY TeamID

/**/
SELECT TeamName,TeamID
FROM Team
/*Count the number of matches per stadium*/
SELECT COUNT(MatchDate) AS 'Nr of matches',StadiumID
FROM Match
GROUP BY StadiumID

/*Display the number of home games each team has played*/
SELECT HomeTeamID,COUNT(MatchDate)
FROM Match
GROUP BY HomeTeamID

SELECT AwayTeamID,COUNT(MatchDate)
FROM Match
GROUP BY AwayTeamID