=====================
Exercises on triggers
=====================

.. highlight:: text

Exercise 1: Flight booking
==========================

Remember the schema from last week about flights and airports:

.. literalinclude:: ../3-queries/flights.schema
   :language: text

Assume the following two tables are added to this schema: a table listing for
each flight the number of available seats and the price per ticket::

  AvailableFlights(_flight_, _date_, numberOfFreeSeats, price)
    flight → Flights.code

And another one listing the passengers that have been booked for each flight,
with the price they have paid and a unique booking reference number (an
integer, to keep things simple)::

  Bookings(_reference_, flight, date, passenger, price)
    (flight, date) → AvailableFlights.(code, date)

**Question 1**
Create a view that lists booking references, passengers, flight codes, date,
and departure and destination cities.

**Question 2**
Create a trigger on the view defined in quesiton one. This trigger takes care
of booking a new passenger to a flight. It is fired by an insertion of a
passenger and a flight code to the view, for instance, “book Annie Adams for
AF666 on 2016-03-18”. Its effect should be the following:

* if the number of free seats on AF666 at this date is positive, decrement it
  by one; the booking is successful
* if there are no free seats, the booking fails
* if the booking is successful, add Annie Adams and AF666 to Bookings at the
  given date, with the price given in ``AvailableFlights`` when booking her;
  also add a booking reference which is the maximum of the previous references
  (for all flights) plus one
* if the booking is successful, increment the price by 50 SEK for the next
  passenger (thus the fuller the flight, the more you pay)

**Question 3**
The airline decides to upgrade its database to keep track of its fleet.  This
means adding a table to list the available planes and updating the
``AvailableFlights`` in the following way::

  Planes(_regnr_, capacity)
  AvailableFlights(_flight_, _date_, numberOfFreeSeats, price, plane)
    (flight, date) → Flights.(code, date)
    plane → Planes.regnr

We now have duplicated information in the database: we can compute the number
of free seats by subtracting the number of booked seats to the capacity of the
plane.  One solution would be to simply remove the ``numberOfFreeSeats`` column
but, as it is often the case with production databases, it is impossible to
update all the systems accessing the database at once to make use of the new
schema, which means that the duplicated field needs to be present in the
database during a transition period.

To make the transition easier, we would like to have the value of the
``numberOfFreeSeats`` automatically updated.  In particular, if a flight
becomes full well before its departure date, the airline company would like to
be able to change the airplane for a bigger one.  Your job is to create a
trigger that automatically update ``numberOfSeats`` when this happens.


Exercise 2: At the restaurant
=============================

In this exercise, we are creating the following database for a restaurant:

.. literalinclude:: restaurant.schema

For the sake of simplicity, we assume that the database only needs to hold
bookings for the current day and that bookings are always done on the hour
(i.e. ``time`` is an integer between 0 and 23).

Finally, tables are always booked for two hours.  This means that if table 1
is booked at 19.00, it can't be booked at 20.00 but it can be booked again at
21.00.

**Question 1**
Write a view that lists the times at which tables are blocked by a booking.  In
the example above, where table 1 is booked at 19.00, the view should contain
the following rows:

===== ====
table time
===== ====
1     18
1     19
1     20
===== ====


**Question 2**
Write a trigger on the table ``Bookings`` that automatically assign a table to
new rows if none is specified.  The assigned table should respect the following
rules:

* it should be free for the duration of the booking.
* it should be big enough for the number of people in the party
* it should be the smallest possible table to accommodate this number of people

Exercise 3: Wiki
================

In this exercise, we are creating a database for a wiki.  A wiki is a website
that *allows collaborative modification of its content and structure directly
from the web browser* (Wikipedia).

To make collaborative edition easier, we needs to keep an history of the
modifications of each page.  To achieve this, we will use a simple model that
simply keeps each version of each page as a separate row::

  PageRevision(_name_, _date_, author, text)

**Question 1**
To make it easier to access the wiki, creat a view
``Page(name, last_author, text)`` that shows only the latest version of each
page.

**Question 2**
Create a trigger on your newly created view so that when a user tries to update
a given page, a new revision is created instead.

Sometimes, pages on the wiki needs to be completely deleted (for instance, if
a page contains sensitive information or copyrighted content).  In that case,
we want to remove all revisions of the page from the database but we still want
to remember that the page has existed but has been deleted.  To this end, we
add the following table to our database::

  DeleteLog(_pagename_, _date_)

**Question 3**
Write a trigger on the ``Page`` view such that when a page is deleted:

* all its revisions are removed from the database
* the deletion is recorded in the ``DeleteLog``.

.. _solution-tutorial4:

Solutions
=========

Material used during the tutorial: :download:`slides <slides.pdf>`,
:download:`handout <handout.pdf>`,
:download:`database setup (exercise 1) <exercise1-setup.sql>`,
:download:`database setup (exercise 2) <exercise2-setup.sql>`,
:download:`database setup (exercise 3) <exercise3-setup.sql>`.

Exercise 1
----------

.. literalinclude:: exercise1-solution-question1.sql
   :caption: Question 1
   :name: exercise1-solution-question1
   :language: postgresql

.. literalinclude:: exercise1-solution-question2.sql
   :caption: Question 2
   :name: exercise1-solution-question2
   :language: postgresql

.. literalinclude:: exercise1-solution-question3.sql
   :caption: Question 3
   :name: exercise1-solution-question3
   :language: postgresql

Exercise 2
----------

.. literalinclude:: exercise2-solution-question1.sql
   :caption: Question 1
   :name: exercise2-solution-question1
   :language: postgresql

.. literalinclude:: exercise2-solution-question2.sql
   :caption: Question 2
   :name: exercise2-solution-question2
   :language: postgresql

Exercise 3
----------

.. literalinclude:: exercise3-solution-question1.sql
   :caption: Question 1
   :name: exercise3-solution-question1
   :language: postgresql

.. literalinclude:: exercise3-solution-question2.sql
   :caption: Question 2
   :name: exercise3-solution-question2
   :language: postgresql

.. literalinclude:: exercise3-solution-question3.sql
   :caption: Question 3
   :name: exercise3-solution-question3
   :language: postgresql
