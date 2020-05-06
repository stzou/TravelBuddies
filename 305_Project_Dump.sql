

CREATE TABLE IF NOT EXISTS Login(
	Email VARCHAR(30) NOT NULL,
    Password VARCHAR(20) NOT NULL,
    Role VARCHAR(30) NOT NULL,
    PRIMARY KEY(EMAIL)
);

CREATE TABLE IF NOT EXISTS Person(
	SSN INTEGER NOT NULL UNIQUE,	
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	ZipCode INTEGER,
	City VARCHAR(30),
	State VARCHAR(30),
	Telephone CHAR(20),
	PRIMARY KEY(SSN)
);

CREATE TABLE IF NOT EXISTS Customer (
	SSN INTEGER,
	AccNum INTEGER NOT NULL,
	AccCreationDate DATE,
	CCNumber INTEGER NOT NULL,
	Email VARCHAR(30) NOT NULL,
	Rating INTEGER,
	Preferences CHAR(200),
	PRIMARY KEY(AccNum),
	FOREIGN KEY (SSN) REFERENCES Person(SSN)
		ON DELETE NO ACTION
		ON UPDATE CASCADE 
);


CREATE TABLE IF NOT EXISTS Employee (
	EmployeeID INTEGER,
	SSN INTEGER,
    Email VARCHAR(30) NOT NULL,
	StartDate DATE,
	HourlyRate INTEGER,
    isManager BOOLEAN,
	PRIMARY KEY(EmployeeID),
	FOREIGN KEY (SSN) REFERENCES Person(SSN)
);

CREATE TABLE IF NOT EXISTS Passenger(
	SSN INTEGER NOT NULL UNIQUE,
	AccNum INTEGER NOT NULL,
    	PRIMARY KEY(SSN, AccNum),
    	FOREIGN KEY(SSN) REFERENCES Person(SSN)
			ON DELETE CASCADE
			ON UPDATE CASCADE, 
    	FOREIGN KEY(AccNum) REFERENCES Customer(AccNum)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Airline (
	ID CHAR(2) NOT NULL,
	Name VARCHAR(20) NOT NULL,
	PRIMARY KEY (ID)
);


CREATE TABLE IF NOT EXISTS Airport(
ID CHAR(3) NOT NULL,
Name VARCHAR(40) NOT NULL,
City VARCHAR(40) NOT NULL, 
Country VARCHAR(40) NOT NULL,
PRIMARY KEY(ID)
);



CREATE TABLE IF NOT EXISTS Flight(
FlightNumber INTEGER NOT NULL,
Airline CHAR(2) NOT NULL,
NumSeats INTEGER,
Day CHAR(7),
MinLengthOfStay INTEGER, 
MaxLengthOfStay INTEGER,
PRIMARY KEY(FlightNumber,Airline,Day),
FOREIGN KEY(Airline) REFERENCES Airline(ID)
	ON DELETE NO ACTION
	ON UPDATE CASCADE, 
CHECK (NumSeats > 0)
);

CREATE TABLE IF NOT EXISTS Fare ( 
AirlineID CHAR(2) NOT NULL, 
FlightNumber INTEGER NOT NULL, 
FareType VARCHAR(20) NOT NULL, 
Class VARCHAR(20) NOT NULL, 
Fare NUMERIC(10,2) NOT NULL, 
PRIMARY KEY (AirlineID, FlightNumber, FareType, Class), 
FOREIGN KEY (AirlineID, FlightNumber) REFERENCES Flight(Airline, FlightNumber)
	ON DELETE NO ACTION
	ON UPDATE CASCADE, 
CHECK (Fare > 0) 
);



CREATE TABLE IF NOT EXISTS Reservations(
ResNum INTEGER UNIQUE,
Date DATE,
DatePurchased DATE,
TotalFare numeric(10,2),
FareRestriction INTEGER,
BookingFee numeric(10.2),
Passenger INTEGER,
PRIMARY KEY (ResNum,Passenger),
FOREIGN KEY (Passenger) REFERENCES Person(SSN)
	ON DELETE NO ACTION
	ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS AdvPurchaseDiscount ( 
AirlineID CHAR(2), 
Days INTEGER NOT NULL, 
DiscountRate NUMERIC(10,2) NOT NULL, 
PRIMARY KEY (AirlineID, Days), 
FOREIGN KEY (AirlineID) REFERENCES Airline(Id)
	ON DELETE NO ACTION
	ON UPDATE CASCADE,
CHECK (Days > 0), 
CHECK (DiscountRate > 0 AND DiscountRate < 100));


CREATE TABLE IF NOT EXISTS Legs (
	LegNum INTEGER,
	ToDes CHAR(3),
	FromDes CHAR(3),
	FlightNumber INTEGER,
	Airline CHAR(2),
	DepartTime DATETIME,
	ArrivalTime DATETIME,
	PRIMARY KEY(FlightNumber, Airline,LegNum),
	FOREIGN KEY(Airline) REFERENCES Airline(ID)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	FOREIGN KEY(ToDes) REFERENCES Airport(ID)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
    FOREIGN KEY(FromDes) REFERENCES Airport(ID)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	FOREIGN KEY(FlightNumber) REFERENCES Flight(FlightNumber)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Includes ( 
	ResNum INTEGER,
	AirlineID CHAR(2), 
	FlightNumber INTEGER, 
	LegNum INTEGER, 
	Date DATETIME NOT NULL, 
	Meal VARCHAR(30),
	SeatNumber CHAR(5) NOT NULL,
	PRIMARY KEY (ResNum, AirlineID, FlightNumber, LegNum), 
	FOREIGN KEY (ResNum) REFERENCES Reservations (ResNum)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	FOREIGN KEY (AirlineID, FlightNumber, LegNum) REFERENCES Legs(Airline, FlightNumber, LegNum) 
		ON DELETE NO ACTION
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Makes (
	AccNum INTEGER,
	CustomerRep INTEGER,
	ResNum INTEGER, 
	PRIMARY KEY (AccNum,CustomerRep,ResNum),
	FOREIGN KEY(CustomerRep) REFERENCES Employee(EmployeeID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY(ResNum) REFERENCES Reservations(ResNum)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY(AccNum) REFERENCES Customer(AccNum)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Belongs(
	AirlineID CHAR(2),
	FlightNumber INTEGER,
	PRIMARY KEY(FlightNumber,AirlineID),
	FOREIGN KEY(FlightNumber) REFERENCES Flight(FlightNumber)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	FOREIGN KEY(AirlineID) REFERENCES Airline(ID)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
);



CREATE TABLE IF NOT EXISTS Auctions (
	AccNum INTEGER,
	Airline CHAR(2),
	FlightNumber INTEGER,
	Class VARCHAR(20),
	Date DATE,
	Offer NUMERIC(10,2) NOT NULL,
	Accepted CHAR(3),
	PRIMARY KEY(AccNum, Airline, FlightNumber, Class, Date),
	FOREIGN KEY(AccNum) REFERENCES Customer(AccNum)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY(Airline, FlightNumber) REFERENCES Flight(Airline, FlightNumber)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
);

INSERT INTO Airline VALUES("AB","Air Berlin");
INSERT INTO Airline VALUES("AJ","Air Japan");
INSERT INTO Airline VALUES("AM","Air Madagascar");
INSERT INTO Airline VALUES("AA","American Airlines");
INSERT INTO Airline VALUES("BA","British Airways");
INSERT INTO Airline VALUES("DA","Delta Airlines");
INSERT INTO Airline VALUES("JB","JetBlue Airways");
INSERT INTO Airline VALUES("LU","Lufthansa");
INSERT INTO Airline VALUES("SW","Southwest Airlines");
INSERT INTO Airline VALUES("UA","United Airlines");

INSERT INTO Airport VALUES("BTE","Berlin Tegel","Berlin","Germany");
INSERT INTO Airport VALUES("CHI","Chicago O'Hare International","Chicago","Illinois");
INSERT INTO Airport VALUES("HJA","Hartsfield-Jackson Atlanta Int","Atlanta","United States of America");
INSERT INTO Airport VALUES("IVI","Ivato International","Antananarivo","Madagascar");
INSERT INTO Airport VALUES("JFK","John F. Kennedy International","New York","United States of America");
INSERT INTO Airport VALUES("LAG","LaGuardia","New York","United States of America");
INSERT INTO Airport VALUES("LOG","Logan International","Boston","United States of America");
INSERT INTO Airport VALUES("LHR","London Heathrow","London","United Kingdom");
INSERT INTO Airport VALUES("LAI","Los Angeles International","Los Angeles","United States of America");
INSERT INTO Airport VALUES("SFI","San Francisco International","San Francisco","United States of America");
INSERT INTO Airport VALUES("TKI","Tokyo International","Tokyo","Japan");

INSERT INTO Flight(FlightNumber,Airline,NumSeats,Day,MinLengthOfStay,MaxLengthOfStay) VALUES(111,"AA",100,"1010100",7,21);
INSERT INTO Flight(FlightNumber,Airline,NumSeats,Day,MinLengthOfStay,MaxLengthOfStay) VALUES(111,"JB",150,"1111111",3,14);
INSERT INTO Flight(FlightNumber,Airline,NumSeats,Day,MinLengthOfStay,MaxLengthOfStay) VALUES(1337,"AM",33,"0000011",7,30);

INSERT INTO Belongs VALUES("AA", 111);
INSERT INTO Belongs VALUES("JB", 111);
INSERT INTO Belongs VALUES("AM", 1337);

INSERT INTO Legs VALUES(1,"LAI","LAG",111,"AA","2011-01-05 11:00:00","2011-01-05 09:00:00");
INSERT INTO Legs VALUES(2,"TKI","LAI",111,"AA","2011-01-05 19:00:00","2011-01-05 17:00:00");
INSERT INTO Legs VALUES(3,"LAG","TKI",111,"AA","2011-01-06 10:00:00","2011-01-06 07:30:00");
INSERT INTO Legs VALUES(1,"LOG","SFI",111,"JB","2011-01-10 14:00:00","2011-01-10 12:00:00");
INSERT INTO Legs VALUES(2,"LHR","LOG",111,"JB","2011-01-10 22:30:00","2011-01-10 19:30:00");
INSERT INTO Legs VALUES(3,"LAI","LHR",111,"JB","2011-01-11 08:00:00","2011-01-11 05:00:00");
INSERT INTO Legs VALUES(1,"IVI","JFK",1337,"AM","2011-01-13 07:00:00","2011-01-13 05:00:00");
INSERT INTO Legs VALUES(2,"SFI","IVI",1337,"AM","2011-01-14 03:00:00","2011-01-13 23:00:00");

INSERT INTO Person VALUES(1, "Jane", "Smith", 17790, "Stony Brook", "New York", "555-555-5555");
INSERT INTO Person VALUES(2, "John", "Doe", 10001, "New York", "New York", "123-123-1234");
INSERT INTO Person VALUES(3, "Rick", "Astley", 90001, "Los Angeles", "California", "314-159-2653");
INSERT INTO Person VALUES(4, "Donald", "Duck", 10002, "New York", "New York", "917-000-0000");
INSERT INTO Person VALUES(5, "Jill", "Smith", 11122, "Brooklyn", "NewYork", "718-111-2222");
INSERT INTO Person VALUES(6, "Will", "Locker", 11342, "Manhattan", "New York", "917-665-2221");
INSERT INTO Person VALUES(7, "Phil", "Wong", 22331, "Syosset", "New York", "718-333-1234");



INSERT INTO Customer VALUES(1, 1, '2000-11-11', 101010, "awesomejane@ftw.com", 9, "Window Seat, Cookies");
INSERT INTO Customer VALUES(2, 2, '1980-12-01', 657846, "jdoe@woot.com", 10, "Fries, Window Seat");
INSERT INTO Customer VALUES(3, 3, '1978-01-21', 432453, "rickroller@rolld.com", 2, "Aisle Seat, Wine");

INSERT INTO Passenger VALUES(1,1);
INSERT INTO Passenger VALUES(2,2);
INSERT INTO Passenger VALUES(3,3);

INSERT INTO Employee VALUES (1,4, "DonaldDuck@gmail.com","2010-01-01",15, FALSE);
INSERT INTO Employee VALUES (2,5, "JillSmith@gmail.com","2010-01-05", 15, FALSE);
INSERT INTO Employee VALUES (3, 6, "WillLocker@gmail.com", "2010-01-01", 20, TRUE);


INSERT INTO Reservations(ResNum,Date, DatePurchased,Passenger, TotalFare, BookingFee, FareRestriction) VALUES (111,"2010-05-12", "2010-04-12", 1, 1200.00, 109.10,21);
INSERT INTO Reservations(ResNum,Date, DatePurchased,Passenger, TotalFare, BookingFee, FareRestriction) VALUES (222,"2010-12-20", "2010-8-20", 2, 500.00, 45.45, 21);
INSERT INTO Reservations(ResNum,Date, DatePurchased,Passenger, TotalFare, BookingFee, FareRestriction) VALUES (333,"2010-12-26", "2010-1-26", 3, 3333.33, 303.03, 14);

INSERT INTO Includes VALUES(111,"AA",111,1, "2011-01-05 11:00:00", "Chips", "33F");
INSERT INTO Includes VALUES(111,"AA",111,2, "2011-01-05 19:00:00", "Chips", "33F");
INSERT INTO Includes VALUES(222,"JB",111,1, "2011-01-14 22:30:00", "Fish and Chips", "13A");
INSERT INTO Includes VALUES(333,"AM",1337,1, "2011-01-13 07:00:00", "Sushi", "1A");

INSERT INTO Auctions VALUES(2,"AA",111,"Economy","2010-05-12",400.00,"Yes");
INSERT INTO Auctions VALUES(1,"AA",111,"Business","2010-06-12",700.00,"No");

INSERT INTO AdvPurchaseDiscount VALUES("AA", 3, 1.00);
INSERT INTO AdvPurchaseDiscount VALUES("AA", 7, 3.00);
INSERT INTO AdvPurchaseDiscount VALUES("AA", 14, 5.00);
INSERT INTO AdvPurchaseDiscount VALUES("AA", 21, 10.00);

INSERT INTO AdvPurchaseDiscount VALUES("DA", 3, 2.50);
INSERT INTO AdvPurchaseDiscount VALUES("DA", 7, 6.00);
INSERT INTO AdvPurchaseDiscount VALUES("DA", 14, 9.00);
INSERT INTO AdvPurchaseDiscount VALUES("DA", 21, 10.00);

INSERT INTO AdvPurchaseDiscount VALUES("JB", 3, 1.50);
INSERT INTO AdvPurchaseDiscount VALUES("JB", 7, 3.50);
INSERT INTO AdvPurchaseDiscount VALUES("JB", 14, 6.00);
INSERT INTO AdvPurchaseDiscount VALUES("JB", 21, 8.50);

INSERT INTO AdvPurchaseDiscount VALUES("UA", 3, 2.00);
INSERT INTO AdvPurchaseDiscount VALUES("UA", 7, 4.00);
INSERT INTO AdvPurchaseDiscount VALUES("UA", 14, 6.00);
INSERT INTO AdvPurchaseDiscount VALUES("UA", 21, 10.00);

INSERT INTO Makes VALUES(1, 2, 111);
INSERT INTO Makes VALUES(2, 2, 222);
INSERT INTO Makes VALUES(3, 2, 333);


INSERT INTO Fare VALUES("AA",111,"roundtrip","Economy",1092.00);
INSERT INTO Fare VALUES("AA",111,"roundtrip","Business",1183.00);
INSERT INTO Fare VALUES("JB",111,"one-way","First",455.00);
INSERT INTO Fare VALUES("JB",111,"one-way","Business",425.00);
INSERT INTO Fare VALUES("AM",1337,"roundtrip","First",3033.00);


INSERT INTO Login VALUES("JillSmith@gmail.com","abcdef","customerRepresentative");
INSERT INTO Login VALUES("DonaldDuck@gmail.com","abcdef","customerRepresentative");
INSERT INTO Login VALUES("WillLocker@gmail.com","abcdef","manager");
INSERT INTO Login VALUES("awesomejane@ftw.com","abcdef","customer");

CREATE VIEW RepRev(CustomerRep,TotalRev) AS				
SELECT M.CustomerRep,SUM(R.TotalFare) FROM Reservations R,Makes M	
WHERE R.ResNum=M.ResNum							
GROUP BY M.CustomerRep; 

CREATE VIEW CustomerRevs(AccNum,TotalRev) AS 
SELECT M.AccNum,SUM(R.TotalFare)
FROM Reservations R,Makes M
WHERE R.ResNum=M.ResNum GROUP BY M.AccNum; 

CREATE VIEW FlightFreq(Airline,FlightNumber,Freq) AS 
SELECT Airline,FlightNumber,COUNT(*) 
FROM Legs 
GROUP BY Airline,FlightNumber;


    
CREATE VIEW FlightRes (AirlineID, FlightNo, ResrCount) AS 
SELECT I.AirlineID, I.FlightNumber, COUNT(DISTINCT I.ResNum) 
FROM Includes I 
Group BY I.AirlineID, I.FlightNumber;

