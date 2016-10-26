DROP TABLE IF EXISTS Airports, Flights, AvailableFlights, Bookings, Planes CASCADE;

CREATE TABLE Airports(
  code                TEXT,
  city                TEXT  NOT NULL,

  PRIMARY KEY (code)
);

CREATE TABLE Flights (
  code                TEXT,
  departureAirport    TEXT  NOT NULL  REFERENCES Airports(code),
  destinationAirport  TEXT  NOT NULL  REFERENCES Airports(code),
  departureTime       INT   NOT NULL  CHECK (departureTime >=0 AND departureTime < 24),
  arrivalTime         INT   NOT NULL  CHECK (arrivalTime >=0 AND arrivalTime < 24),

  PRIMARY KEY (code)
);

CREATE TABLE Planes(
  regnr TEXT,
  capacity INT NOT NULL,

  PRIMARY KEY (regnr),
  CHECK (capacity > 0)
);

CREATE TABLE AvailableFlights(
  flight              TEXT,
  date                TEXT,
  numberOfFreeSeats   INT   NOT NULL  CHECK (numberOfFreeSeats > 0),
  price               INT   NOT NULL  CHECK (price > 0),
  plane               TEXT  NOT NULL,

  PRIMARY KEY (flight, date),
  FOREIGN KEY (flight) REFERENCES Flights(code),
  FOREIGN KEY (plane) REFERENCES Planes(regnr)
);

CREATE TABLE Bookings(
  reference           INT,
  flight              TEXT  NOT NULL,
  date                TEXT  NOT NULL,
  passenger           TEXT  NOT NULL,
  price               INT   NOT NULL,

  PRIMARY KEY (reference),
  FOREIGN KEY (flight, date) REFERENCES AvailableFlights(flight, date)
);


-- Some data
COPY airports (code, city) FROM stdin;
AKH	Arkham
DNW	Dunwich
ISM	Innsmouth
KPT	Kingsport
\.

COPY flights (code, departureAirport, destinationAirport, departureTime, arrivalTime) FROM stdin;
HPL1933	DNW	AKH	00	04
HPL1936	ISM	AKH	02	05
HPL1929	AKH	DNW	06	10
HPL1920	KPT	ISM	00	05
HPL1921	DNW	KPT	00	02
\.

COPY Planes (regnr, capacity) FROM stdin;
small1	100
small2	100
small3	100
small4	100
big1	200
big2	200
\.

COPY AvailableFlights (flight, date, numberOfFreeSeats, price, plane) FROM stdin;
HPL1933	2016-02-24	2	100	big1
HPL1936	2016-02-24	3	100	small2
HPL1929	2016-02-24	4	100	big1
HPL1920	2016-02-24	5	100	small3
HPL1921	2016-02-24	6	100	small4
\.
