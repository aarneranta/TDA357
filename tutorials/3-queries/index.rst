==============================
Relational algebra and queries
==============================

.. highlight:: text

*The solution to the first exercise is now available.*

Exercise 1: Air trafic
======================
In the questions that follow, we need information about departure and arrival
times. We assume the following relations have been implemented as tables in
SQL:

.. literalinclude:: flights.schema
   :language: text

The listed flight code is the prime flight (i.e. the one used by the operating
airline). For simplicity, we assume that ``departure`` and ``arrival``
are integers denoting full hours, all in the same time zone, and that
``0 ≤ departure < arrival < 24``.

**Question 1**
Using this schema, write an SQL query that finds all airports that have
departures or arrivals (or both) of flights operated by Lufthansa or SAS (or
both).

**Question 2**
Using the schema, write an SQL query that shows the names of all cities
together with the number of flights that depart from them, and sorts them by
the number of flights in descending order (i.e. the city with the largest
number of departures first).

**Question 3**
Using the above schema, write a view that lists all connections from any city X
to any other city Y involving 1 or 2 legs (i.e. separate flights between two
cities: if you fly from Gothenburg to Paris with a change in Frankfurt, the
connection has two legs).

The query must return a table with the following information (and nothing
else):

* the departure city X and destination city Y
* the departure time from X and the arrival time in Y
* the number of legs
* the total time from departure in X to arrival in Y
* the total time spent in the air

A change is possible if and only if

#. it happens at the same airport,
#. the changing time is at least 1 hour, and
#. the connecting flight is on the same day.

*Note: In the following questions, we don’t care about the set/multiset
distinction.*

**Question 4**
Express the query of question 1 by a relational algebra expression.

**Question 5**
Translate the following relational algebra expression to an SQL query:

.. math::
    \begin{split}
      \pi_{First.departure, Second.arrival}(
        \rho_{First}(Flights)
        \bowtie_{First.destination = Second.origin}
        \rho_{Second}(Flights)
      )
    \end{split}


Exercise 2: Music website
=========================

The domain for this exercise is that of a database for the catalogue of an
online music streaming site.  You are given the following schema of their
intended database::

    Tracks(trackId,title, length)
        length > 0
    Artists(artistId, name)
    Albums(albumId,title, yearReleased)
    TracksOnAlbum(album,trackNr,track)
        album → Albums.albumId
        track → Tracks.trackId
        (album,track) unique
        trackNr > 0
    Participates(track, artist)
        track → Tracks.trackId
        artist → Artists.artistId
    Users(username, email, name)
        email unique
    Playlists(user, playlistName)
        user → Users.username
    InList(user, playlist, number,track)
        (user, playlist) → Playlists.(user, playlistName)
        track → Tracks.trackId
    PlayLog(user,time,track)
        user → Users.username
        track → Tracks.trackId
        (user,time) unique

An artist can be either a solo artist or a group, the design makes no
difference between the two kinds. Tracks are recorded by one or more artists,
and each track can appear on one or more albums (but no more than once on each
album) to account for e.g. “Greatest hits” or collection albums.

Users of the site can register, in order to create playlists, which are simply
ordered collections of tracks.

Finally, the system stores a log over all songs played by registered users, to
calculate statistics and to give suggestions and feedback.  (Note: The actual
music files to be streamed is considered to be stored separately, outside the
scope of this schema.)

.. note:: When you are asked to list all X, you need only return the key
   attributes of X.

**Question 1**
Write an SQL query that lists all artists appearing on any album released this
year (2016).

**Question 2**
Write an SQL query that lists, for each user, how many playlists that user has.

**Question 3**
Write an SQL query that lists, for each track, its ``trackId`` and title,
together with the number of times that track has been played, and the number of
distinct users that have played it.

**Question 4**
Write an SQL query that finds the title, length and album title of the longest
track in the database. If the track appears on more than one album, list the
album where it appeared first. If more than one track of the same length
qualifies, list the one that was released first, as given by the album it
appears on. If there is still a tie, list all such tracks.

**Question 5**
What does the following relational algebra expression compute (answer in plain
text):

.. math::
   \tau_x(
     \gamma_{playlistName,COUNT(∗)\rightarrow x}(
       \sigma_{playlistName=playlist}(Playlists \times InList)
     )
   )

**Question 6**
Translate the following relational algebra expression(s) to corresponding SQL:

.. math::
   let\ R1 = \gamma_{user,track,COUNT(∗)→nrTimes}(PlayLog)

   \sigma_{avgNrTimes>=10}(\gamma_{track,AVG(nrTimes)→avgNrTimes}(R1))

**Question 7**
Translate the following SQL query to relational algebra::

   SELECT album, MAX(trackNr) AS nrOfTracks, SUM(length) AS totalLength
   FROM Albums, TracksOnAlbum, Tracks
   WHERE albumId = album
   AND trackId = track
   GROUP BY albumId
   ORDER BY totalLength DESC;

**Question 8**
Write a relational algebra expression that lists the artist(s) appearing in the
highest number of distinct playlists. In case of a tie for highest number of
different playlists, list all such artists.

.. _solution-tutorial3:

Solution
========

.. note:: Solution to the first exercise.  You can find a slightly different
   solution in :download:`the 2015 exam solution <../../exam/VT2015_soln.pdf>`.

.. note:: Solution to the first exercise as solved in 
   :download:`the exercise session of 2016/11/25 <Tutorial3_airTraffic_20161128.txt>`.

Exercise 1
~~~~~~~~~~

Question 1
----------

::

   select distinct airport
   from (
     select destinationAirport as airport, airlineName
     from Flights join FlightCodes
       using (code)
   union
   select departureAirport as airport, airlineName
     from Flights natural join FlightCodes
   ) as airportsandairlines
     where airlineName like 'Lufthansa%'
       or airlineName like 'Scandinavian%'
     order by airport;

Question 2
----------

::

  select city, count(Flights.code) as nbflights
    from Airports, Flights
    where Airports.code = departureAirport
    group by city
    order by nbflights desc;

Question 3
----------

::

  create view connectedCities as
  select A1.city as origin,
         A2.city as destination,
         departureTime, arrivalTime, 1 as legs,
         arrivalTime - departureTime as totalTime,
         arrivalTime - departureTime as flightTime
    from Flights, Airports as A1, Airports as A2
    where departureAirport = A1.code
      and destinationAirport = A2.code
  union
  select A1.city as origin,
         A2.city as destination,
         F1.departureTime, F2.arrivalTime, 2 as legs,
         F2.arrivalTime - F1.departureTime as totalTime,
         F1.arrivalTime - F1.departureTime
          + (F2.arrivalTime - F2.departureTime)
          as flightTime
    from Flights as F1, Flights as F2,
         Airports as A1, Airports as A2
    where F1.departureAirport = A1.code
      and F2.destinationAirport = A2.code
      and F1.destinationAirport = F2.departureAirport
      and F2.departureTime > F1.arrivalTime
  ;

Question 4
----------

.. math::
      \delta
      \pi_{airport}\left(
    \begin{multline}
        \pi_{destinationAirport \rightarrow airport, airlineName}(Flights \bowtie FlightCodes)\\
        \cup\\
        \pi_{departureAirport \rightarrow airport, airlineName}(Flights \bowtie FlightCodes)
    \end{multline}
      \right)

Question 5
----------

::

  select Firs.departure, second.arival
    from Flights as First
      join Flights as Second
      on (First.destination = Second.origin)


.. note:: You can download the data used during the tutorial
   :download:`Exercise1.zip`, :download:`Exercise2.zip` as well as the :download:`slides <slides.pdf>` and
   :download:`handout <handout.pdf>`
