CREATE OR REPLACE FUNCTION assign_table() RETURNS TRIGGER AS $$
BEGIN

  NEW.tablenum :=(
    WITH possible_tables AS (
      SELECT number, seats
      FROM tables
      WHERE (number, new.time) NOT IN (SELECT * FROM BlockedTables)
        AND seats >= new.nbpeople
    )
    SELECT MIN(number)
    FROM possible_tables
    WHERE seats = (SELECT MIN(seats) FROM possible_tables));

    IF (NEW.tablenum IS NULL) THEN
      RAISE EXCEPTION 'No table available';
    END IF;

  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS AssignTable ON Bookings;

CREATE TRIGGER AssignTable BEFORE INSERT ON Bookings
  FOR EACH ROW
  WHEN (NEW.tablenum IS NULL)
  EXECUTE PROCEDURE assign_table();
