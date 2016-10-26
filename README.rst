===============
Database Course
===============

Course site |build status|
==========================

.. |build status| image:: https://ci.zjyto.net/job/DBCourse/badge/icon

Building the site locally
-------------------------

To build the site, you need to have `sphinx <http://sphinx-doc.org/>`_
installed with the rtd theme.  On fedora, you can install them like this::

  dnf install python-sphinx python-sphinx_rtd_theme

On Ubuntu::

  sudo apt-get install python-sphinx
  sudo pip install sphinx_rtd_theme


Once you have sphinx, you can generate the html pages with::

  make html

The generated html pages can be found in ``./_build/html/``.

The site content is written in reStructuredText, a simple markup language
somewhat similar to markdown or txt2tag.  See `reStructuredText Primer
<http://www.sphinx-doc.org/en/stable/rest.html#hyperlinks>`_ for an
introduction.
