-- Connecting to Chalmers postgresql server:
-- psql -h ate.ita.chalmers.se -U <username>

-- Reverse order because GivenCourses depend on People and Courses
-- If we remove People or Courses first, the references in GivenCourses
-- become invalid, and psql complains.
DROP TABLE IF EXISTS GivenCourses;
DROP TABLE IF EXISTS People;
DROP TABLE IF EXISTS Courses;


-- three tables: People, Courses and GivenCourses
CREATE TABLE People (
    ssn 		INTEGER,
    name 		TEXT 		NOT NULL,
    PRIMARY KEY (ssn)
);

CREATE TABLE Courses (
    code 		CHAR(6),
    name 		TEXT 		NOT NULL,
    PRIMARY KEY (code)
);

CREATE TABLE GivenCourses (
    code 		CHAR(6) 	REFERENCES Courses,
    period 		INTEGER 	CHECK(period in (1,2,3,4)),
    studentcount 	INTEGER 	CHECK(studentcount >= 0) NOT NULL,
    teacherssn 		INTEGER 	REFERENCES People(ssn) NOT NULL,
    PRIMARY KEY (code, period)
);


-- Create some example people
INSERT INTO People (ssn, name) VALUES (1, 'Steven Van Acker');
INSERT INTO People (ssn, name) VALUES (2, 'Niklas Broberg');
INSERT INTO People (ssn, name) VALUES (3, 'Aarne Ranta');
INSERT INTO People (ssn, name) VALUES (4, 'Graham Kemp');

-- Create some example courses
INSERT INTO Courses (code, name) VALUES ('TDA357', 'Databases');
INSERT INTO Courses (code, name) VALUES ('TIN090', 'Algorithms');

-- Create some example givencourses
INSERT INTO GivenCourses (code, period, studentcount, teacherssn) VALUES ('TDA357', 2, 199, 1);
INSERT INTO GivenCourses (code, period, studentcount, teacherssn) VALUES ('TDA357', 3, 75, 4);
INSERT INTO GivenCourses (code, period, studentcount, teacherssn) VALUES ('TIN090', 1, 120, 2);
INSERT INTO GivenCourses (code, period, studentcount, teacherssn) VALUES ('TIN090', 2, 151, 2);
INSERT INTO GivenCourses (code, period, studentcount, teacherssn) VALUES ('TIN090', 3, 103, 2);
INSERT INTO GivenCourses (code, period, studentcount, teacherssn) VALUES ('TIN090', 4, 3, 2);

-- example (cartesian or cross) product query
SELECT c.code, c.name, g.period, g.studentcount, p.ssn, p.name 
    FROM Courses c, GivenCourses g, People p 
    WHERE c.code = g.code AND g.teacherssn = p.ssn;

-- example delete query
DELETE from GivenCourses WHERE studentcount < 20;

-- example update query
UPDATE GivenCourses SET teacherssn = 3 WHERE period = 3;

-- example (cartesian or cross) product query (again, to see the changes)
SELECT c.code, c.name, g.period, g.studentcount, p.ssn, p.name 
    FROM Courses c, GivenCourses g, People p 
    WHERE c.code = g.code AND g.teacherssn = p.ssn;

-- same query, but written with JOIN
SELECT * 
    FROM Courses JOIN GivenCourses ON Courses.code = GivenCourses.code
    	JOIN People ON GivenCourses.teacherssn = People.ssn;

-- same query, but now also using NATURAL JOIN
SELECT * 
    FROM Courses NATURAL JOIN GivenCourses
    	JOIN People ON GivenCourses.teacherssn = People.ssn;
