CREATE OR REPLACE VIEW BlockedTables AS
SELECT tablenum, time - 1 FROM Bookings WHERE time > 0
UNION
SELECT tablenum, time FROM Bookings
UNION
SELECT tablenum, time + 1 FROM Bookings WHERE time < 23;
