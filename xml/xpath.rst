Xpath
=====

::

    XPATH(1)                                                              XPATH(1)



    NAME
           Xpath - simple XPath interpreter

    SYNOPSIS
           Xpath XML_FILE XPATH_FILE

    DESCRIPTION
           A  simple script that takes input from an XML file that is specified by
           the first command line argument and evaluates the XPath  expression  in
           the  file  that  is specified by the second command line argument using
           Saxon.

           The results are wrapped by Saxon so that these form a single XML  docu-
           ment.  The resulting XML document is formatted using xmllint.

    AUTHOR
           Graham J.L. Kemp <kemp@chalmers.se>.

    SEE ALSO
           http://www.saxonica.com/documentation/using-xquery/commandline.xml
           xmllint()



    Xpath                            November 2011                        XPATH(1)
