DROP TABLE if exists Tables, Bookings CASCADE;

CREATE TABLE Tables(
  tablenum  INT PRIMARY KEY,
  seats     INT NOT NULL
);

CREATE TABLE Bookings(
  name      TEXT,
  time      INT,
  nbpeople  INT NOT NULL,
  tablenum  INT NOT NULL REFERENCES Tables(tablenum),

  PRIMARY KEY (name, time)
);

COPY Tables from stdin;
1	2
2	2
3	4
4	4
5	6
6	6
7	8
\.

COPY Bookings FROM stdin;
Tintin	19	2	1
Bianca Castafiore	20	5	4
\.
