-- These queries build on top of lecture5.sql

-- remove the views created in this lecture, if needed (for a clean start)
DROP VIEW IF EXISTS FullPicture;
DROP VIEW IF EXISTS BetterPeople;

DROP TABLE Lectures;
DROP TABLE Rooms;
DROP TABLE BadRooms;





-- column names can be output in different order, or even repeated
SELECT name, ssn FROM People;
SELECT ssn, name, name, name FROM People;

-- columns can also be temporarily renamed (e.g. ssn is renamed to id)
SELECT ssn AS id, name FROM People;

-- A JOIN from the previous lecture...
SELECT * from People JOIN GivenCourses on People.ssn = GivenCourses.teacherssn;
-- ... can be transformed into a NATURAL JOIN by using a subquery which renames 'ssn' to 'teacherssn' in People
-- (note that we can also rename relations/tables. In this case, the subquery has no name and a name is required,
--  so we name it BetterPeople)
SELECT * from (SELECT ssn AS teacherssn, name AS teachername FROM People) as BetterPeople NATURAL JOIN GivenCourses;

-- We can also rewrite this for readability as:
WITH BetterPeople AS (SELECT ssn AS teacherssn, name AS teachername FROM People)
  SELECT * from BetterPeople NATURAL JOIN GivenCourses;





-- Instead of temporarily creating a relation/table BetterPeople, we can also make it permanent
-- as a view:
CREATE VIEW BetterPeople AS (SELECT ssn AS teacherssn, name AS teachername FROM People);
-- ... and then treat BetterPeople as any other table:
SELECT * from BetterPeople NATURAL JOIN GivenCourses;


-- Let's create a FullPicture VIEW which combines People, Courses and GivenCourses
CREATE VIEW FullPicture AS 
  SELECT code, name, period, studentcount, teacherssn, teachername
    FROM Courses NATURAL JOIN GivenCourses NATURAL JOIN BetterPeople;

----
-- The power of WHERE
----

-- Creating Rooms and Lectures tables with some data
CREATE TABLE Rooms(
    roomname VARCHAR(10),
    capacity INTEGER CHECK(capacity > 0) NOT NULL,
    campus TEXT NOT NULL,
    PRIMARY KEY(roomname)
);

CREATE TABLE Lectures(
    code CHAR(6),
    period INTEGER,
    roomname VARCHAR(10) REFERENCES Rooms,
    weekday TEXT CHECK(weekday IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    FOREIGN KEY(code, period) REFERENCES GivenCourses(code, period),
    PRIMARY KEY(code, period, weekday)
);

INSERT INTO Rooms(roomname, capacity, campus) VALUES('HB2', 186, 'Johanneberg');
INSERT INTO Rooms(roomname, capacity, campus) VALUES('HC1', 105, 'Johanneberg');
INSERT INTO Rooms(roomname, capacity, campus) VALUES('HC2', 115, 'Johanneberg');
INSERT INTO Rooms(roomname, capacity, campus) VALUES('Jupiter44', 64, 'Lindholmen');
INSERT INTO Rooms(roomname, capacity, campus) VALUES('Svea239', 60, 'Lindholmen');
INSERT INTO Rooms(roomname, capacity, campus) VALUES('VR', 300, 'Neverland');

INSERT INTO Lectures(code, period, roomname, weekday) VALUES('TDA357', 2, 'HB2', 'Tuesday');
INSERT INTO Lectures(code, period, roomname, weekday) VALUES('TDA357', 2, 'HB2', 'Wednesday');
INSERT INTO Lectures(code, period, roomname, weekday) VALUES('TIN090', 2, 'Svea239', 'Friday');
INSERT INTO Lectures(code, period, roomname, weekday) VALUES('TDA357', 3, 'HC1', 'Monday');


------ IN/ANY/ALL/EXISTS/...
-- select all givencourses in either period 1 or 3
SELECT * FROM GivenCourses WHERE period IN(1,3);
SELECT * FROM GivenCourses WHERE period = ANY (ARRAY[1,3]);

-- select all entries from the courses table, if their 'code' matches a course in the lectures table
SELECT * FROM Courses WHERE EXISTS (SELECT * FROM Lectures WHERE Courses.code = Lectures.code);

-- select all rooms with a capacity that can fit each of the studentgroups listed in GivenCourses
SELECT * FROM Rooms WHERE capacity >= ALL(SELECT studentcount FROM GivenCourses);

----- arithmetic/constants
SELECT 1;
SELECT 1 + 1;
SELECT 'hello world' AS test;

-- find all lectures where rooms have at least 10 free seats
SELECT * FROM Lectures NATURAL JOIN Rooms NATURAL JOIN GivenCourses WHERE studentcount <= capacity - 10;

-- Beware of how SELECT operates! In this example, 'abc' is returned for every row in People
SELECT 'abc' FROM People;

----- String operators

-- Strings can also be compared using < > <= >= etc.
SELECT * FROM People WHERE name > 'Donald Duck';

-- the LIKE operator allows matching substrings
SELECT * FROM People WHERE name LIKE '%er%';

----- Aggregate functions. These are special since they work across multiple rows!

-- calculate the total capacity of all known rooms together
SELECT SUM(capacity) FROM Rooms;

-- calculate min, max and average amount of students over all given courses
SELECT MIN(studentcount), MAX(studentcount), AVG(studentcount) FROM GivenCourses;

-- Count the number of entries in People
SELECT COUNT(*) FROM People;


-- list all attributes of the room with the largest capacity
-- Note that we have to use  subquery here, because of the peculiar nature of the aggregate functions
SELECT * FROM Rooms WHERE capacity = (SELECT MAX(capacity) FROM Rooms);

-- for instance, this won't work:
-- SELECT * FROM Rooms WHERE capacity = MAX(capacity);

----- NULL's peculiar behavior (three-valued logic)
CREATE TABLE BadRooms(
    roomname VARCHAR(10),
    capacity INTEGER CHECK(capacity > 0), -- capacity is nullable now!
    campus TEXT NOT NULL,
    PRIMARY KEY(roomname)
);

INSERT INTO BadRooms(roomname, capacity, campus) VALUES('A',  10, 'Johanneberg');
INSERT INTO BadRooms(roomname, capacity, campus) VALUES('B',  40, 'Johanneberg');
INSERT INTO BadRooms(roomname, capacity, campus) VALUES('C', 100, 'Johanneberg');
INSERT INTO BadRooms(roomname, capacity, campus) VALUES('D', NULL, 'Johanneberg');

-- select all rooms that have either more than 50 or less-or-equal than 50 capacity
-- logically, this should be all rooms, but this will not take any NULLs into account
SELECT * FROM BadRooms WHERE capacity > 50 OR capacity <= 50;

-- aggregate functions ignore NULL values. If calculated over all 4 rows, the average should (mathematically) be 37.5, not 50
SELECT AVG(capacity) FROM BadRooms;

