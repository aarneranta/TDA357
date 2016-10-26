CREATE OR REPLACE FUNCTION insert_itinerary() RETURNS TRIGGER AS $$
DECLARE
  ticket_price INTEGER;
  new_reference INTEGER;
BEGIN
  -- First, check that there are at least one seat left on the flight
  IF NOT 0 < (SELECT numberOfFreeSeats FROM AvailableFlights WHERE flight = NEW.flight)
    THEN RAISE EXCEPTION 'Flight fully booked';
  END IF;

  ticket_price := (SELECT price FROM AvailableFlights WHERE flight = NEW.flight);
  new_reference := (
    SELECT COALESCE(MAX(reference), 0) + 1
    FROM Bookings
    WHERE flight = new.flight
  );

  INSERT INTO Bookings(reference, flight, date, passenger, price)
    VALUES (new_reference, NEW.flight, NEW.date, NEW.passenger, ticket_price);

  UPDATE AvailableFlights
  SET price = price + 1
  WHERE flight = new.flight;

  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS InsertItinerary ON Itineraries;

CREATE TRIGGER InsertItinerary INSTEAD OF INSERT ON Itineraries
  FOR EACH ROW EXECUTE PROCEDURE insert_itinerary();
