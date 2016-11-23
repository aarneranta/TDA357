-- These queries build on top of lecture5.sql, lecture6.sql and lecture7.sql
DROP TRIGGER IF EXISTS myTrigger ON GivenCourses;


-- mirror all rooms to Neverland by using INSERT from a subquery
INSERT INTO Rooms (SELECT CONCAT('X', roomname), capacity, 'Neverland' FROM Rooms WHERE campus != 'Neverland');
-- remove them again to not disturb future uses of these SQL files
DELETE FROM Rooms WHERE roomname like 'X%';


-- Example of 'ON DELETE CASCADE' and 'ON DELETE RESTRICT'
DROP TABLE IF EXISTS ExamsCascade;
DROP TABLE IF EXISTS ExamsRestrict;
DELETE FROM GivenCourses WHERE code = 'TDA357' and period = 4;

CREATE TABLE ExamsCascade (
    code                CHAR(6),
    period              INTEGER,
    examdate        	DATE,
    FOREIGN KEY (code, period) REFERENCES GivenCourses(code, period)
    	ON DELETE CASCADE
	ON UPDATE CASCADE,
    PRIMARY KEY(code, period)
);

CREATE TABLE ExamsRestrict (
    code                CHAR(6),
    period              INTEGER,
    examdate        	DATE,
    FOREIGN KEY (code, period) REFERENCES GivenCourses(code, period)
    	ON DELETE RESTRICT,
    PRIMARY KEY(code, period)
);

---- create a new GivenCourse
INSERT INTO GivenCourses(code, period, studentcount, teacherssn) VALUES('TDA357', 4, 100, 1);
---- schedule an exam
INSERT INTO ExamsCascade(code, period, examdate) VALUES('TDA357', 4, DATE('1969-07-24'));
SELECT * FROM ExamsCascade;
---- update the givencourse and change TDA357 to TIN090, will also update the ExamsCascade table
UPDATE GivenCourses SET code='TIN090' WHERE code = 'TDA357' and period = 4;
SELECT * FROM ExamsCascade;
---- deleting the givencourses entry, will also delete from the ExamsCascade table
DELETE FROM GivenCourses WHERE code = 'TIN090' and period = 4;
SELECT * FROM ExamsCascade;


---- create a new GivenCourse
INSERT INTO GivenCourses(code, period, studentcount, teacherssn) VALUES('TDA357', 4, 100, 1);
---- schedule an exam
INSERT INTO ExamsRestrict(code, period, examdate) VALUES('TDA357', 4, DATE('1969-07-24'));
---- now delete the givencourse...
DELETE FROM GivenCourses WHERE code = 'TDA357' and period = 4; -- This SQL statement results in an expected error!
---- because of "RESTRICT", the GivenCourse was not deleted, and neither was the ExamsRestrict entry
SELECT * FROM GivenCourses WHERE code = 'TDA357' and period = 4;
SELECT * FROM ExamsRestrict;

-- cleanup
DELETE FROM ExamsRestrict WHERE code = 'TDA357' and period = 4;
DELETE FROM GivenCourses WHERE code = 'TDA357' and period = 4;


-- QUIZ: No teacher may hold more than 1 course at a time
SELECT 
	NOT EXISTS( 
		SELECT count(code), period, teachername 
		FROM fullpicture 
		GROUP BY period, teachername 
		HAVING count(code) > 1
		);


----
----
-- Triggers as assertions
----
----

-- Make sure teacherssn does not teach in period 4, so we are not confused by the results later.
DELETE FROM GivenCourses WHERE teacherssn = 1 and period = 4;

-- Since assertions don't exist in postgresql, we emulate one with a trigger.
-- The following function will be executed to test if the assertion holds.
-- If it does not hold, an exception is raised.
CREATE OR REPLACE FUNCTION myFunction() RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS ( 
		SELECT count(code), period, teacherssn 
		FROM fullpicture 
		WHERE teacherssn = NEW.teacherssn AND period = NEW.period
		GROUP BY period, teacherssn 
		HAVING count(code) > 0
	)
	    THEN RAISE EXCEPTION 'teachers should not hold more than 1 course!!';
	ELSE
	    RETURN NEW;
	END IF;
END
$$ LANGUAGE 'plpgsql';

-- Next, we can define a trigger on GivenCourses which will be executed before any INSERT,
-- calling the function myFunction on every row. 
CREATE TRIGGER myTrigger BEFORE INSERT ON GivenCourses 
    FOR EACH ROW
    EXECUTE PROCEDURE myFunction();

-- Now let's have someone teach TDA357 in period 4
INSERT INTO GivenCourses(code, period, studentcount, teacherssn) VALUES('TDA357', 4, 100, 1);
-- and have the same person teach TIN090 in period 4
-- This last insert will fail because it triggers the assertion that noone can teach more than 1 course per period
INSERT INTO GivenCourses(code, period, studentcount, teacherssn) VALUES('TIN090', 4, 100, 1); -- This SQL statement results in an expected error!

-- cleanup
DELETE FROM GivenCourses WHERE teacherssn = 1 and period = 4;


----
----
-- Triggers to update views
----
----

-- This stored procedure will handle insertions into the FullPicture view
-- Remember that FullPicture = Courses NATURAL JOIN GivenCourses NATURAL JOIN BetterPeople
CREATE OR REPLACE FUNCTION insertInFullpicture() RETURNS TRIGGER AS $$
BEGIN
    -- check if the teacher already exists with the same data
    IF NOT EXISTS(SELECT ssn FROM People WHERE ssn = NEW.teacherssn AND name = NEW.teachername)
    THEN
        INSERT INTO People(ssn, name) VALUES(NEW.teacherssn, NEW.teachername);
    END IF;

    -- check if the course already exists with the same data
    IF NOT EXISTS(SELECT code FROM Courses WHERE code = NEW.code AND name = NEW.name)
    THEN
        INSERT INTO Courses(code, name) VALUES(NEW.code, NEW.name);
    END IF;

    -- check if the givencourse already exists with the same data
    IF NOT EXISTS(SELECT code FROM GivenCourses WHERE code = NEW.code AND period = NEW.period AND studentcount = NEW.studentcount AND teacherssn = NEW.teacherssn)
    THEN
        INSERT INTO GivenCourses(code, period, studentcount, teacherssn) VALUES(NEW.code, NEW.period, NEW.studentcount, NEW.teacherssn);
    END IF;
    RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

-- This trigger will call insertInFullpicture() INSTEAD OF an INSERT on FullPicture
CREATE TRIGGER onInsertFullPicture INSTEAD OF INSERT ON FullPicture 
    FOR EACH ROW
    EXECUTE PROCEDURE insertInFullpicture();

-- Now we can insert into the FullPicture view, thereby updating the underlying tables
INSERT INTO FullPicture(code, name, period, studentcount, teacherssn, teachername) VALUES('POK000', 'Pokemon Hunting', 3, 1000, 7, 'Mickey Mouse');

-- To verify, check all the underlying tables
SELECT * FROM People WHERE ssn = 7;
SELECT * FROM BetterPeople WHERE teacherssn = 7; -- BetterPeople is an updatable view on People
SELECT * FROM Courses WHERE code = 'POK000';
SELECT * FROM GivenCourses WHERE code = 'POK000';
SELECT * FROM FullPicture WHERE code = 'POK000';


