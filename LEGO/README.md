AnyBeam OpenSCAD Library 
====

This library provides the anybeam() module that can be used to create beams with a variety of hole, axle and slot patterns using a simple declaritive syntax. 

**NOTE** - This library requires OpenSCAD version 2013.06 or higher because of it's use of recursion. 

**Syntax** 

    anybeam( [ BEAM, CONNECTION, BEAM, CONNECTION ... ], HEIGHT )

 * HEIGHT - Height in standard beam height units. Use 1/3 to create thin beams.
 * BEAM - A beam string, See below.
 * CONNECTION - A connection array. See below.

Beam String
-----

A beam is speficied as a string of characters, each character representing type of hole in a straight beam.

    O  Pin hole  
    X  Axle hole  
    (  Half hole with a slot on the right.  
    )  Half hole with the slot on the left.  
    -  (dash) A full width slot, use with ( and ) to create 
       long slots with half hole ends like "(--)" (4 span slot) or "()" (2 span slot)  
    _  (underscore) Skip this hole.  

For example: 

    XOOOOX   - Size 6 beam with axle holes at the ends.   
    OOXOO    - Size 5 beam with an axle hole in the middle.  
    (---)OOO - Size 8 beam with a size 5 slot and 3 holes.  


Beam Connector
----

A connection vector connects two beams. 

    [ PREVIOUS_BEAM_HOLE, NEXT_BEAM_HOLE, NEXT_BEAM_ANGLE ]  

 * Holes are numbered from left to right starting at 1. 
 * Angles in degrees. The angle is relative to the previous beam and may be negative. 

For example, a 4x2 right angle lift arm: 
  
    [ "XOOO", [ 4, 1, 90 ],  "OO" ]  

The connection hole specifier may include a fractional part. A 4x2 beam with the size 2 beam attached at the mid point of the size 4 beam (2.5 holes). Note the use of the period in the second beam to avoid hole overlap between the 2nd and 3rd hole of the first beam.

    [ "XOOO", [ 2.5, 1, 90 ], ".O" ]  

Complete Examples
----

A size 12 beam with two 45 degree bends at holes 7 and 10 and a size two slot between holes 8 and 9. 

    anybeam( [ "XOOOOOO", [ 7, 1, 45 ], " () ", [ 4, 1, 45 ], "OOO" ] )

A cross 5x5 cross with an axle hole in the centre.

    anybeam( [ "OOXOO", [ 3, 3, 90 ], "OOXOO" ] )


