CREATE OR REPLACE VIEW Itineraries AS
  SELECT
    reference, passenger, flight, date,
    departure.city as departure, destination.city as destination
  FROM
    Bookings
    JOIN Flights ON Bookings.flight = Flights.code
    JOIN Airports AS Departure ON departureAirport = Departure.code
    JOIN Airports AS Destination ON destinationAirport = Destination.code;
