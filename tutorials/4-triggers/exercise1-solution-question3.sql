CREATE OR REPLACE FUNCTION update_plane() RETURNS TRIGGER AS $$
DECLARE
  size_difference INTEGER;
BEGIN
  size_difference :=
    (SELECT capacity FROM Planes WHERE regnr=new.plane)
    - (SELECT capacity FROM Planes WHERE regnr = old.plane);

  if (new.numberOfFreeSeats + size_difference < 0) THEN
    RAISE EXCEPTION 'Plane too small!';
  ELSE
    new.numberOfFreeSeats := new.numberOfFreeSeats + size_difference;
  END IF;

  RETURN new;
END
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS UpdatePlane ON AvailableFlights;

CREATE TRIGGER UpdatePlane BEFORE UPDATE ON AvailableFlights
  FOR EACH ROW
  WHEN (new.plane <> old.plane)
  EXECUTE PROCEDURE update_plane();
