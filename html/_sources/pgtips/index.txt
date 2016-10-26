PostgreSQL Tips
===============

Logging in to PostgreSQL using psql
-----------------------------------

:command:`psql` is a simple command-line client for the PostgreSQL database
and should be available on the linux machine at the university.

Assuming your account is `tda357_XXX`, you connect to the database as follow:

.. code-block:: bash

    psql -h ate.ita.chalmers.se -U tda357_XXX

Enter you password and you will then get a prompt where you can type sql
commands, e.g.:

.. code-block:: psql

    tda357_XXX=> CREATE TABLE h2g2 ( the_answer INT );
    CREATE TABLE
    tda357_XXX=> INSERT INTO h2g2 VALUES (42);
    INSERT 0 1
    tda357_XXX=> SELECT * FROM h2g2;
    the_answer
    ------------
             42
    (1 row)

    tda357_XXX=> \q


Note: ``\q`` quits psql.


Connecting to the database using PostgreSQL Studio
--------------------------------------------------

.. _PostgreSQL Studio:
    https://postgresql.portal.chalmers.se/pgstudio/

An alternative way to connect to the database is to use the web interface
provided by `PostgreSQL Studio`_.

.. image:: pgstudio-main.png
    :align: center
    :alt: PostgreSQL Studio main interface

You can login in PostgreSQL Studio with the same credential you would use with
psql, specifying ``localhost`` as the *Database Host*.

.. image:: pgstudio-login-small.png
    :alt: PostgreSQL Studio login window
    :align: center

PostgreSQL Studio allows you to modify your tables, views, triggers and data
using a graphical interface.  But beware that, when submitting the different
labs, you still need to have a script that can re-create your database from
scratch.


Connecting from outside Chalmers
--------------------------------

The database server is not accessible from outside the Chalmers network.  This
means that if you try the command above, ``psql`` will not be able to connect.

If you want to work from home, or anywhere outside Chalmers, you
first need to connect to the Chalmers network using a VPN.  See instructions
for `Linux <linux vpn_>`_, `Mac <mac vpn_>`_ and `Windows <win vpn_>`_

.. _linux vpn:
   https://student.portal.chalmers.se/en/contactservice/ITServices
   /self-administered/linux/remote/Sidor/vpn.aspx
.. _mac vpn:
   https://student.portal.chalmers.se/en/contactservice/ITServices
   /self-administered/mac/remote/Sidor/vpn.aspx
.. _win vpn:
   https://student.portal.chalmers.se/en/contactservice/ITServices
   /self-administered/windows/remote/Sidor/VPN.aspx


Changing Your Password
----------------------

You can change your PostgreSQL password by executing the command::

    ALTER USER <username> WITH PASSWORD '<newpassword>';

Where ``<username>`` is your PostgreSQL username, and ``<newpassword>`` is the
password you would like to use in the future. This command, like all other SQL
commands, should be terminated with a semicolon.


Getting Information About Your Schema
-------------------------------------

If you need to inspect your database, you can use psql commands.  For instance,
``\d`` will list all tables and views, or ``\dft`` will list all trigger
functions.  Use ``\?`` to get a list of all the available commands and their
description.


.. _delete-everything:

Deleting Everything
-------------------

The following line can be run to delete all of your tables, views and
triggers::


    DROP OWNED BY <username> CASCADE;
