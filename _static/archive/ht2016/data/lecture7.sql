-- These queries build on top of lecture5.sql and lecture6.sql

-- To list the rooms with the largest capacity
SELECT roomname, capacity FROM Rooms WHERE capacity = (SELECT MAX(capacity) FROM Rooms);

-- To list the campus with largest combined capacity, we have to group by campus first
-- and aggregate per group
SELECT campus, SUM(capacity) FROM Rooms GROUP BY campus;

-- an alternative way:
SELECT DISTINCT campus, (SELECT SUM(capacity) FROM Rooms r2 WHERE r2.campus=r1.campus) FROM Rooms r1;

-- List all campuses with a capacity over 200
-- Note that we can't use WHERE here, because the filter uses an aggregate function
SELECT campus, SUM(capacity) FROM Rooms GROUP BY campus HAVING SUM(capacity) > 200;

-- List all rooms sorted by descending capacity
SELECT * FROM Rooms ORDER BY capacity DESC;

-- UNION between 2 relations with similar columns
-- Note that this UNION makes no sense, since we are mixing Rooms and People, yet SQL happily allows it
-- The first column is a text field, the second is a number
SELECT roomname, capacity FROM Rooms UNION SELECT name, ssn FROM People;


-- List all periods in which courses are given, except those in which lectures are given
-- This means: find all given courses that have no lectures
-- (This query removes all duplicates from both SELECTs before EXCEPT)
SELECT period FROM FullPicture EXCEPT SELECT period FROM Lectures;
-- (This query removes does not remove duplicates from either SELECTs before EXCEPT)
SELECT period FROM FullPicture EXCEPT ALL SELECT period FROM Lectures;

-- List all teachers that give a course, avoid duplicates
SELECT DISTINCT teachername FROM FullPicture;

-- Common idiom: List all rooms with the courses taught in them. If there is no course, list NULL
SELECT roomname, code FROM Lectures NATURAL JOIN Rooms 
	UNION 
	SELECT roomname, NULL FROM Rooms WHERE roomname NOT IN (SELECT roomname FROM Lectures);




-- Different types of joins, in this case all NATURAL
SELECT * FROM FullPicture NATURAL JOIN Lectures;
SELECT * FROM FullPicture NATURAL FULL OUTER JOIN Lectures;
SELECT * FROM FullPicture NATURAL LEFT OUTER JOIN Lectures;
SELECT * FROM FullPicture NATURAL RIGHT OUTER JOIN Lectures;

-- full outer join between 3 tables
SELECT * FROM FullPicture NATURAL FULL OUTER JOIN Lectures NATURAL FULL OUTER JOIN Rooms;


