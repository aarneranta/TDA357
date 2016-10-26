Using XPath and XQuery
======================

.. toctree::
   :hidden:

   xpath
   xquery

You can use the programs :doc:`Xpath <xpath>` (note: upper case X) and
:doc:`xquery <xquery>` on the Linux system at Chalmers to experiment with XPath
and XQuery expressions. These programs use the `Saxon XPath/XQuery processor
<http://saxon.sourceforge.net/>`__.

Example XML files
-----------------

These XML examples are used in the lectures:

-  :download:`courses.xml <courses.xml>`
-  :download:`scheduler.xml <scheduler.xml>`

These XML files have been validated using the `W3C validation
service <http://validator.w3.org/>`__.

XPath examples
--------------

.. code-block:: xml

    bash$ cat example1.xp
    /Courses/*/*
    bash$ Xpath courses.xml example1.xp
    <?xml version="1.0" encoding="UTF-8"?>
    <result:sequence xmlns:result="http://saxon.sf.net/xquery-results" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <result:element>
        <GivenIn period="2" teacher="Niklas Broberg"/>
      </result:element>
      <result:element>
        <GivenIn period="4" teacher="Rogardt Heldal"/>
      </result:element>
      <result:element>
        <GivenIn period="1" teacher="Devdatt Dubhashi"/>
      </result:element>
    </result:sequence>

    bash$ cat example2.xp
    //*
    bash$ Xpath courses.xml example2.xp
    <?xml version="1.0" encoding="UTF-8"?>
    <result:sequence xmlns:result="http://saxon.sf.net/xquery-results" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <result:element>
        <Courses>
          <Course name="Databases" code="TDA357">
            <GivenIn period="2" teacher="Niklas Broberg"/>
            <GivenIn period="4" teacher="Rogardt Heldal"/>
          </Course>
          <Course name="Algorithms" code="TIN090">
            <GivenIn period="1" teacher="Devdatt Dubhashi"/>
          </Course>
        </Courses>
      </result:element>
      <result:element>
        <Course name="Databases" code="TDA357">
          <GivenIn period="2" teacher="Niklas Broberg"/>
          <GivenIn period="4" teacher="Rogardt Heldal"/>
        </Course>
      </result:element>
      <result:element>
        <GivenIn period="2" teacher="Niklas Broberg"/>
      </result:element>
      <result:element>
        <GivenIn period="4" teacher="Rogardt Heldal"/>
      </result:element>
      <result:element>
        <Course name="Algorithms" code="TIN090">
          <GivenIn period="1" teacher="Devdatt Dubhashi"/>
        </Course>
      </result:element>
      <result:element>
        <GivenIn period="1" teacher="Devdatt Dubhashi"/>
      </result:element>
    </result:sequence>

    bash$ cat example3.xp
    /Courses/Course/.
    bash$ Xpath courses.xml example3.xp
    <?xml version="1.0" encoding="UTF-8"?>
    <result:sequence xmlns:result="http://saxon.sf.net/xquery-results" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <result:element>
        <Course name="Databases" code="TDA357">
          <GivenIn period="2" teacher="Niklas Broberg"/>
          <GivenIn period="4" teacher="Rogardt Heldal"/>
        </Course>
      </result:element>
      <result:element>
        <Course name="Algorithms" code="TIN090">
          <GivenIn period="1" teacher="Devdatt Dubhashi"/>
        </Course>
      </result:element>
    </result:sequence>

    bash$ cat example4.xp
    /Courses/Course
    bash$ Xpath courses.xml example4.xp
    <?xml version="1.0" encoding="UTF-8"?>
    <result:sequence xmlns:result="http://saxon.sf.net/xquery-results" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <result:element>
        <Course name="Databases" code="TDA357">
          <GivenIn period="2" teacher="Niklas Broberg"/>
          <GivenIn period="4" teacher="Rogardt Heldal"/>
        </Course>
      </result:element>
      <result:element>
        <Course name="Algorithms" code="TIN090">
          <GivenIn period="1" teacher="Devdatt Dubhashi"/>
        </Course>
      </result:element>
    </result:sequence>

    bash$ cat example5.xp
    //GivenIn/..
    bash$ Xpath courses.xml example5.xp
    <?xml version="1.0" encoding="UTF-8"?>
    <result:sequence xmlns:result="http://saxon.sf.net/xquery-results" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <result:element>
        <Course name="Databases" code="TDA357">
          <GivenIn period="2" teacher="Niklas Broberg"/>
          <GivenIn period="4" teacher="Rogardt Heldal"/>
        </Course>
      </result:element>
      <result:element>
        <Course name="Algorithms" code="TIN090">
          <GivenIn period="1" teacher="Devdatt Dubhashi"/>
        </Course>
      </result:element>
    </result:sequence>

    bash$ cat example6.xp
    /Courses/Course/GivenIn[@period=2]
    bash$ Xpath courses.xml example6.xp
    <?xml version="1.0" encoding="UTF-8"?>
    <result:sequence xmlns:result="http://saxon.sf.net/xquery-results" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <result:element>
        <GivenIn period="2" teacher="Niklas Broberg"/>
      </result:element>
    </result:sequence>

    bash$ cat example7.xp
    /Courses/Course[GivenIn/@period="2"]
    bash$ Xpath courses.xml example7.xp
    <?xml version="1.0" encoding="UTF-8"?>
    <result:sequence xmlns:result="http://saxon.sf.net/xquery-results" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <result:element>
        <Course name="Databases" code="TDA357">
          <GivenIn period="2" teacher="Niklas Broberg"/>
          <GivenIn period="4" teacher="Rogardt Heldal"/>
        </Course>
      </result:element>
    </result:sequence>

    bash$ cat example8.xp
    /Courses/Course/@name
    bash$ Xpath courses.xml example8.xp
    <?xml version="1.0" encoding="UTF-8"?>
    <result:sequence xmlns:result="http://saxon.sf.net/xquery-results" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <result:attribute name="Databases"/>
      <result:attribute name="Algorithms"/>
    </result:sequence>

    bash$ cat example9.xp
    //@name
    bash$ Xpath scheduler.xml example9.xp
    <?xml version="1.0" encoding="UTF-8"?>
    <result:sequence xmlns:result="http://saxon.sf.net/xquery-results" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <result:attribute name="Databases"/>
      <result:attribute name="VR"/>
      <result:attribute name="HB1"/>
    </result:sequence>

XQuery examples
---------------

.. code-block:: xml

    bash$ cat example1.xq
    let $courses := doc("courses.xml")
    for $gc in $courses//GivenIn
    where $gc/@period = 2
    return <Result>{$gc}</Result>
    bash$ xquery example1.xq
    <?xml version="1.0" encoding="UTF-8"?>
    <Result>
      <GivenIn period="2" teacher="Niklas Broberg"/>
    </Result>

    bash$ cat example2.xq
    let $courses := doc("courses.xml")
    let $gc := $courses//GivenIn[@period = 2]
    return <Result>{$gc}</Result>
    bash$ xquery example2.xq
    <?xml version="1.0" encoding="UTF-8"?>
    <Result>
      <GivenIn period="2" teacher="Niklas Broberg"/>
    </Result>

    bash$ cat example3.xq
    let $courses := doc("courses.xml")
    for $c in $courses/Courses/Course
    let $code := $c/@code
    let $given := $c/GivenIn
    where $c/GivenIn/@period = 2
    return <Result code="{$code}">{$given}</Result>
    bash$ xquery example3.xq
    <?xml version="1.0" encoding="UTF-8"?>
    <Result code="TDA357">
      <GivenIn period="2" teacher="Niklas Broberg"/>
      <GivenIn period="4" teacher="Rogardt Heldal"/>
    </Result>

    bash$ cat example4.xq
    let $courses := doc("courses.xml")
    for $c in $courses/Courses/Course
    let $code := $c/@code, $name := $c/@name
    let $gc := $c/GivenIn[@period = 2]
    where not(empty($gc))
    return <Course code="{$code}" name="{$name}">{$gc}</Course>
    bash$ xquery example4.xq
    <?xml version="1.0" encoding="UTF-8"?>
    <Course name="Databases" code="TDA357">
      <GivenIn period="2" teacher="Niklas Broberg"/>
    </Course>

    bash$ cat example5.xq
    let $courses := doc("courses.xml")
    let $ct := (
        for $c in $courses/Courses/Course
        for $gc in $courses/Courses/Course/GivenIn
        return <Info name="{$c/@name}" teacher="{$gc/@teacher}" /> )
    return <Result>{$ct}</Result>
    bash$ xquery example5.xq
    <?xml version="1.0" encoding="UTF-8"?>
    <Result>
      <Info name="Databases" teacher="Niklas Broberg"/>
      <Info name="Databases" teacher="Rogardt Heldal"/>
      <Info name="Databases" teacher="Devdatt Dubhashi"/>
      <Info name="Algorithms" teacher="Niklas Broberg"/>
      <Info name="Algorithms" teacher="Rogardt Heldal"/>
      <Info name="Algorithms" teacher="Devdatt Dubhashi"/>
    </Result>
