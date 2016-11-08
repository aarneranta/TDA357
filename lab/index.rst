Programming Assignment
======================


Purpose
~~~~~~~

The purpose of this assignment is for you to get hands-on experience with
designing, constructing and using a database for a real-world domain. You will
see all aspects of database creation, from understanding the domain to using
the final database from external applications.

Assignment submission and deadlines
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. toctree::
    :hidden:

    submission

To pass the programming assignment, you must pass all five tasks described on
this page. You will do the assignment in groups of two.

You must submit your solutions through the Fire reporting system. Read the
separate notes on :doc:`registering in the Fire system, submitting assignment
tasks and requesting your group's PostgreSQL account <submission>`.

You must submit your group's solutions to each task by the given deadline.
After submission, your assignment will be graded ("pass" or "reject") and you
will receive comments on your solution (for tasks 1, 2, 3 and 4). If your
submission is rejected, you are allowed to refine your solution and re-submit
it.

To pass the final part of the assignment, you must demonstrate your system to
one of the teachers. Your files for task 5 must be uploaded to the Fire system
**after** you have demonstrated your system, and **before** the task 5
deadline.

Introduction
~~~~~~~~~~~~

In this assignment you will design and construct a database, together with a
front end application, that handles university students and courses. You will
do this in five distinct tasks:

#. :ref:`task1`
#. :ref:`task2`
#. :ref:`task3`
#. :ref:`task4`
#. :ref:`task5`

Each consecutive task will be based on the previous, so it is one single
assignment that you will do. It will not be possible to only do the
fifth task for instance, since you will then have no database to build
your application on.

For each task you will hand in and get feedback on your results. Since
errors in one task may propagate to the next one, it is wise to hand in
your solutions early to get more chances for feedback.

Be sure to read through the full description of the assignment before
you start since the requirements we place on the system must influence
your initial design as well.

Domain description
~~~~~~~~~~~~~~~~~~

The domain that you will model in this assignment is that of courses and
students at a university. So as not to make the task too large and
unspecified, you will here get a description of the domain that
restricts the problem somewhat. Note that the described domain is not
identical to Chalmers or GU.

The university for which you are building this system is organized into
departments for employees, such as the Dept. of Computing Science (CS),
and study programmes for students, such as the Computer Science and
Engineering programme (CSEP). Programmes are hosted by departments, but
several departments may collaborate on a programme, which is the case
with CSEP that is co-hosted by the CS department and the Department of
Computer Engineering (CE). Department names and abbreviations are
unique, as are programme names but not necessarily abbreviations.

Each study programme is further divided into branches, for example CSEP
has branches Computer Languages, Algorithms, Software Engineering etc.
Note that branch names are unique within a given programme, but not
necessarily across several programmes. For instance, both CSEP and a
programme in Automation Technology could have a branch called
Interaction Design. For each study programme, there are mandatory
courses. For each branch, there are additional mandatory courses that
the students taking that branch must read. Branches also name a set of
recommended courses from which all students taking that branch must read
a certain amount to fulfill the requirements of graduation, see below.

A student always belongs to a programme. Students must pick a single
branch within that programme, and fulfill its graduation requirements,
in order to graduate. Typically students choose which branch to take in
their fourth year, which means that students who are in the early parts
of their studies may not yet belong to any branch.

Courses are given by a department (e.g. CS gives the Databases course),
and may be read by students reading any study programme. Some courses
may be mandatory for certain programmes, but not so for others. Students
get credits for passing courses, the exact number may vary between
courses (but all students get the same number of credits for the same
course). Some, but not all, courses have a restriction on the number of
students that may take the course at the same time. Courses can be
classified as being mathematical courses, research courses or seminar
courses. Not all courses need to be classified, and some courses may
have more than one classification. The university will occasionally
introduce other classifications. Some courses have prerequisites, i.e.
other courses that must be read before a student is allowed to register
to it.

Students need to register for courses in order to read them. To be
allowed to register, the student must first fulfill all prerequisites
for the course. It should not be possible for a student to register to a
course unless the prerequisite courses are already passed. It should not
be possible for a student to register for a course which they have
already passed.

If a course becomes full, subsequent registering students are put on a
waiting list. If one of the previously registered students decides to
drop out, such that there is an open slot on the course, that slot is
given to the student who has waited the longest. When the course is
finished, all students are graded on a scale of 'U', '3', '4', '5'.
Getting a 'U' means the student has not passed the course, while the
other grades denote various degrees of success.

A study administrator can override both course prerequisite requirements
and size restrictions and add a student directly as registered to a
course. (Note: you will not implement any front end application for
study administrators, only for students. The database must still be able
to handle this situation.)

For a student to graduate there are a number of requirements she must
first fulfill. She must have passed (have at least grade 3) in all
mandatory courses of the study programme she belongs to, as well as the
mandatory courses of the particular branch that she must have chosen.
Also she must have passed at least 10 credits worth of courses among the
recommended courses for the branch. Furthermore she needs to have read
and passed (at least) 20 credits worth of courses classified as
mathematical courses, 10 credits worth of courses classified as research
courses, and one seminar course. Mandatory and recommended courses that
are also classified in some way are counted just like any other course.
As an example, if one of the mandatory courses of a programme is also a
seminar course, students of that programme will not be required to read
any more seminar courses.

System Specification
~~~~~~~~~~~~~~~~~~~~

You will design and implement a database for the above domain, and a
front end application intended for students of the university. Through
the application they should be able to see their own information,
register to, and unregister from courses.

Formally, your application should have the following modes:

-  Info: Given a students national identification number, the system
   should provide

   -  the name of the student, the students national identification
      number and their university issued login name/ID (something
      similar to how the CID works for chalmers students)
   -  the programme and branch (if any) that the student is following.
   -  the courses that the student has read, along with the grade.
   -  the courses that the student is registered to.
   -  whether or not the student fulfills the requirements for
      graduation

-  Register: Given a student id number and a course code, the system
   should try to register the student for that course. If the course is
   full, the student should be placed in the waiting list for that
   course. If the student has already passed the course, or is already
   registered, or does not meet the prerequisites for the course, the
   registration should fail. The system should notify the student of the
   outcome of the attempted registration, and the reason for failure (if
   any).
-  Unregister: Given a student id number and a course code, the system
   should unregister the student from that course. If there are students
   waiting to be registered, and there is now room on the course, the
   one first in line should be registered for the course. The system
   should acknowledge the removed registration for the student. If the
   student is not registered to the course when trying to unregister,
   the system need not notify this, but no student from the waiting list
   (if applicable) should be promoted in that case.

.. _task1:

Task 1: Designing the database schema (I)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. toctree::
    :hidden:

    dia

Your first task is to design the database that your application will
use. The goal of this task and the next is to reach a correct database
schema that could later be implemented in PostgreSQL.

#. You are to create an E/R diagram that correctly models the domain described
   above. Hint: if your diagram does not contain (at least) one weak entity,
   (at least) one ISA relationship, and (at least) one many-to-at-most-one
   relationship, you have done something wrong. You can use any tool you like
   for this task, as long as you hand in your solution as an image in one of
   the formats ``.png``, ``.jpg``, ``.gif`` or ``.pdf``.  The tool :doc:`Dia
   <dia>` is available on the school computer system, has a mode for ER
   diagrams, and can export diagrams to image files, but using any other tool
   is also OK.
#. When your E/R diagram is complete, you should translate it, using the
   (mostly) mechanical translation rules (see :download:`this
   document <Translation.pdf>` for a summary), into a database schema
   consisting of a set of relations, complete with column names, keys and
   references.

.. Important::
    For task 1, you should hand in

    - :file:`diagram.X`: your E/R diagram, where ``.X`` is one of ``.png``,
      ``.jpg``, ``.gif`` or ``.pdf``.
    - :file:`schema1.txt`: the database schema that you
      get from translating the diagram into tables. If submitting a text file,
      clearly mark keys (e.g. ``_key_``). If any attribute can be null,
      indicate so by writing ``(nullable)`` or similar next to it. If you have
      made any non-obvious choices, when choosing which translation apporoach
      to use (e.g. ER or Null) include a comment about why you decided on using
      it.

    **No .doc files!**

    **Deadline: Sunday 2016-11-20 before 23.59**

.. _task2:

Task 2: Designing the database schema (II)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Your second task is to ensure that the database correctly captures all
constraints of the domain, not just those induced by the translation of
your diagram, by the use of functional dependencies.

#. Identify the functional dependencies that you expect should hold for
   the domain. Do this starting from the domain description and the set
   of attributes in your schema from task 1. **Do not only look for
   functional dependencies in your relation schemas!** If you do, then
   any potential errors in your schema would not be caught, nor will you
   find any extra contraints not already captured by the relational
   structure! At least one such constraint exists in the domain. You
   should **always** look for the functional dependencies in the domain
   description. Remember to check for functional dependencies with
   multiple attributes on the left-hand side of the arrow.
#. When you have found all interesting dependencies, they should
   **then** be checked against the relations from task 1. For any
   constraints not already captured by your relation schema, either

   -  add the extra constraint to your schema, or
   -  argue why your schema should not capture the constraint (see e.g.
      the difference between 3NF and BCNF for why not all constraints
      can be captured).

#. Further, do the same for any constraints needed to handle cyclic
   relationships in your diagram. Specifically, address the issue
   concerning a student's programme and branch.

Here is a non-exhaustive list of things you may want to consider when
searching for functional dependencies:

-  department names and addresses
-  study programme names and abbreviations
-  branch names
-  student names and identification numbers
-  student programmes and branches
-  course names and codes
-  course classifications and prerequisites
-  course waiting lists
-  . . .

.. important:: For task 2, you should hand in

    - :file:`fds.txt`: the full list of functional dependencies that you have
      identified for the domain, in a ``.txt`` file.
    - :file:`schema2.txt` : the database schema that you
      get after updating your schema from task 1 with any added constraints.

    **No .doc files!**

    **Deadline: Sunday 2016-11-27 before 23.59**

.. _task3:

Task 3: Constructing the database (I)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When your design of the database has been approved, the next task is to
construct the database by implementing the database schema in a database engine
(PostgreSQL).

#. You should create all tables, marking key and foreign key constraints in the
   process, and you should also insert checks that ensure that only valid data
   can be inserted in the database. Examples of invalid data would be the grade
   '6', or a course that takes a negative number of students.
#. When you have created the tables, you should fill the tables with example
   data. This can be time-consuming, but it is an important part of the
   development of a database. Having data in the database is crucial in order
   to properly verify that it behaves the way that you expect it to. You should
   fill the tables with enough data so that it is possible to test that your
   application can handle the various operations specified above. Just
   inserting tons of data is of no use if the data still doesn't test all parts
   of the database. Here is a (very) non-exhaustive list of data you will need
   to include:

   - A handful of students, at least one of which fulfils the requirements for
     graduation and a couple that do not for different reasons.
   - A number of courses that test all of the various aspects a course.  This
     includes classifications, mandatory, recommended etc. You need at least
     three waiting students for two different (limited) courses.

   **Important:** When you insert data in the database, do it by writing the
   insert statements in a file that can then be executed.  This way you won't
   have to re-do all the work if there is something that you need to change
   with the table.
#. Since you know exactly what information your application will need from the
   database, in what forms, it is a good idea to write views that provide that
   information in a simple form. In a real setting, we would even ensure using
   privileges that the application *cannot* work with anything but these views.
   Unfortunately we cannot let you test working with privileges on the
   PostgreSQL machine we use, but we will still expect your application to
   adhere to the privileges we list.

   Following the system specification, create these views:

   View: ``StudentsFollowing``
       For all students, their basic information (name etc.), and the programme
       and branch (if any) they are following.
   View: ``FinishedCourses``
       For all students, all finished courses, along with their names, grades
       (grade ``'U'``, ``'3'``, ``'4'`` or ``'5'``) and number of credits.
   View: ``Registrations``
       All registered and waiting students for all courses, along with their
       waiting status (``'registered'`` or ``'waiting'``).
   View: ``PassedCourses``
       For all students, all passed courses, i.e. courses finished with a grade
       other than 'U', and the number of credits for those courses. This view
       is intended as a helper view towards the ``PathToGraduation`` view (and
       for task 4), and will not be directly used by your application.
   View: ``UnreadMandatory``
       For all students, the mandatory courses (branch and programme) they have
       not yet passed. This view is intended as a helper view towards the
       ``PathToGraduation`` view, and will not be directly used by your
       application.
   View: ``PathToGraduation``
       For all students, their path to graduation, i.e. a view with columns for

       -  the number of credits they have taken.
       -  the number of mandatory courses they have yet to read (branch
          or programme).
       -  the number of credits they have taken in courses that are
          classified as math courses.
       -  the number of credits they have taken in courses that are
          classified as research courses.
       -  the number of seminar courses they have read.
       -  whether or not they qualify for graduation.

.. important:: For task 3, you should hand in

    - :file:`tables.sql`: your SQL code for creating the tables.
    - :file:`insert.sql`: your .sql file that contains the insert statements
      for the data.
    - :file:`views.sql`: your SQL code for creating the listed views.

    Note that SQL code should be in plain text format. Make sure that
    PostgreSQL can execute your files before you hand them in. Test this by
    clearing out your database (e.g. using the :ref:`instructions for deleting
    everything <delete-everything>`) and then running
    your SQL files.

    **Deadline: Sunday 2016-12-04 before 23.59**

.. _task4:

Task 4: Constructing the database (II)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. _pg_trigger_example:
   http://www.postgresql.org/docs/current/static/
   plpgsql-trigger.html#PLPGSQL-TRIGGER-EXAMPLE

When your tables and views are implemented correctly, the next task is to
create two triggers to handle some key issues in registration and
unregistration.  `Here <pg_trigger_example_>`_ is a piece of code to get you
started on the first trigger. But first, you should define one more view that
can be used by your triggers, and your application in Task 4:

View: ``CourseQueuePositions``
    For all students who are in the queue for a course, the course code, the
    student's identification number, and the student's current place in the
    queue (the student who is first in a queue will have place "1" in that
    queue, etc.).

When a student tries to register for a course, it is possible that the course
is already full, in which case the student should be put in the waiting list
for that course. When a student unregisters, it might be that there is now room
for some student who is in the waiting list, and who should then be registered
for the course instead. Such things are typically handled via triggers. You
should write two triggers that:

#. when a student tries to register for a course that is full, that student is
   added to the waiting list for the course. Be sure to check that the student
   may actually register for the course before adding to either list, if it may
   not you should raise an error (use `RAISE EXCEPTION
   <http://www.postgresql.org/docs/current/static/plpgsql-errors-and-messages.html>`_).
   Hint: There are several requirements for registration stated in the domain
   description, and some implicit ones like that a student can not be both
   waiting and registered for the same course at the same time.
#. when a student unregisters from a course if the student was properly
   registered and not only on the waiting list, the first student (if any) in
   the waiting list should be registered for the course instead.  Note: this
   should only be done if there is actually room on the course (the course
   might have been over-full due to an administrator overriding the restriction
   and adding students directly).

You need to write the triggers on the view ``Registrations`` instead of on the
tables themselves (third bullet under task 3 above). (One reason for this is
that we "pretend" that you only have the privileges listed under Task 4, which
means you cannot insert data into, or delete data from, the underlying tables
directly. But even if we lift this restriction, there is another reason for not
defining these triggers on the underlying tables - can you figure out why?)

**Prepare test cases (in SQL) for testing both insertion and deletion to check
the triggers work. Make sure your test suite covers all the points listed under
task 5, that we will check the complete application for.**

.. important:: For task 4, you should hand in

    - :file:`triggers.sql`: your SQL code for creating the two triggers.
    - :file:`triggertest.sql`: your SQL code for testing insertion and deletion
    - :file:`setup.sql`: SQL code that sets up your database for testing the
      triggers. This will normally be the concatenation of files
      :file:`tables.sql`, :file:`insert.sql` and :file:`views.sql` from :ref:`Task 2 <task2>`
      but there might be some small differences (e.g. it might be necessary to
      insert different data to make it easier to test the triggers).  We should
      be able to test your triggers by executing files :file:`setup.sql`,
      :file:`triggers.sql` and :file:`triggertest.sql` (in that order).

    Note that SQL code should be in plain text format. **Make sure that
    PostgreSQL can execute your files before you hand them in.**

    **Deadline: Sunday 2016-12-11 before 23.59**

.. _task5:

Task 5: Writing a front end application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The last part of this assignment is to write an application that students can
use to communicate with your database. This application should be a Java
program that uses JDBC to connect to the PostgreSQL database to request and
insert the proper data.

To your help when writing your application we provide you with a stub file that
contains the code for connecting to PostgreSQL on the local system. It also
contains hooks for the three operating modes of the application, and this is
where you should insert your code. The idea is that you should not need to
focus so much on the pure Java parts of the application, but rather get
straight down to business with the database-interfacing code.

The stub file, :download:`StudentPortal.java`, looks like this (the yellow
highlighting shows the part you need to edit):

.. literalinclude:: StudentPortal.java
    :language: java
    :emphasize-lines: 17-18,83,92,101
    :linenos:

The intended behavior of the program is that you use it from the command line,
giving some student identification number as an argument (what exactly that is
depends on your design). This corresponds to the student "logging on" to the
portal. Once logged on, the student can choose one of the three modes
"Information", "Register" or "Unregister". If the first is chosen, all
information for that student should be printed.  Exactly what information must
be printed is given by the system requirements specified above. If one of the
latter modes are chosen, the student will be prompted for a course to register
to or unregister from, and the application should perform the requested
operation and print the result (success, failure).

The stub file above can be compiled and run as it is, only nothing will happen
in any of the modes. Your task is thus to fill in the actual logic of these
three tasks.

Running your application could look like this:

.. code-block:: text

    $> java StudentPortal 123456-7890
    Welcome!
    Please choose a mode of operation:
    ? > i
    Information for student 123456-7890
    -------------------------------------
    Name: Emilia Emilsson
    Student ID: emem
    Line: Information Technology (IT)
    Branch: Systems Development

    Read courses (name (code), credits: grade):
     Set Theory (MAT050), 5p: 5
     Functional Programming (TDA450), 10p: 5
     Object-Oriented Systems Development (TDA590), 10p:  4

    Registered courses (name (code): status):
     Databases (TDA356): registered
     Algorithms (TIN090): waiting as nr 3

    Seminar courses taken: 0
    Math credits taken: 5
    Research credits taken: 0
    Total credits taken: 25
    Fulfills the requirements for graduation: no
    -------------------------------------

    Please choose a mode of operation:
    ? > r TDA350
    You are now successfully registered to course TDA350 Cryptograhy!

    Please choose a mode of operation:
    ? > r TDA381
    Course TDA381 Concurrent Programming is full, you are put in the
    waiting list.

    Please choose a mode of operaion:
    ? > quit
    Goodbye!
    $>

Note that the exact formatting is only a suggestion, you may choose to format
your output differently as long as you give the proper information back to the
user.

To get access to the PostgreSQL jdbc drivers from your application, you should
download it from https://jdbc.postgresql.org and import it into your java
CLASSPATH.

Alternatively you can import the file into an Eclipse project if you are using
it.

Your student application should behave as if it has **only** the following
privileges:

-  ``SELECT ON Courses``
-  ``SELECT ON StudentsFollowing``
-  ``SELECT ON FinishedCourses``
-  ``SELECT ON Registrations``
-  ``SELECT ON CourseQueuePositions``
-  ``SELECT ON PathToGraduation``
-  ``INSERT ON Registrations``
-  ``DELETE ON Registrations``

We will check your submitted code to ensure that you adhere to these
privileges, even though we cannot get the system to enforce them automatically.

.. important:: For task 5 you should hand in

    -  The source code for your Java application **but read below!**.

    However, the fifth task will not be corrected through the submission
    system, even though you should still submit your source code. Instead
    you should come to one of the supervision sessions and demonstrate your
    running application, and we will accept or reject it on the spot
    (pending the check of the submitted code for authority violations). As
    you probably realize, if all of you wait until the last Friday we will
    quite simply not have time for everyone, so come early!

    Here is a list of what we will test your application for:

    #. List info for a student.
    #. Register the student for an unrestricted course, and show that they end
       up registered (show info again).
    #. Register the same student for the same course again, and show that the
       program doesn't crash, and that the student gets an error message.
    #. Unregister the student from the course, and then unregister again from
       the same course. Show that the student is unregistered.
    #. Register the student for a course that they don't have the prerequisites
       for, and show that the registration doesn't go through.
    #. Unregister the student from a restricted course that they are registered
       to, and which has at least two students in the queue.  Register again to
       the same course and show that the student gets the correct (last)
       position in the waiting list.
    #. Unregister, unregister again and re-register the same student for the
       same restricted course, and show that the student is first removed and
       then ends up in the same position as before (last).
    #. Finally, unregister a student from an *overfull* course, i.e. one with
       more students registered than there are places on the course (you need
       to set this situation up in the database directly). Show that no student
       was moved from the queue to being registered as a result.

    Ensure that the data you have put into your system can handle all these
    cases. Please prepare before you ask us to check your application, so
    that running through these cases will be smooth. Please fill the following 
    form before demonstration (:download:`demo form <../_tex/demo-form.pdf>` )


    **Students should demo their working project before or on the last lab session (2016-12-16)**
