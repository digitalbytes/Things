//
// Anybeam Library
//
// This library provides an anybeam() module that can be used to create beams
// with a variaty of hole, axle and slot patterns using a simple declaritive syntax. 
// 
// Pin holes, slots and axle holes of a beam are specified with a string. Each
// character in the string represents one of the following hole types.
//
//  O  Pin hole
//  X  Axle hole
//  (  Half hole with a slot on the right.
//  )  Half hole with the slot on the left.
//  -  A full width slot, use with (, - and ) to create long slots with half hole ends like "(---)" or "()"
//     (space) Skip this hole.
//
// Use the above symbols to represent the hole layout on the beam:
//
//   XOOOOX   - Size 6 beam with axle holes at the ends.
//   OOXOO    - Size 5 beam with an axle hole in the middle.
//   (---)OOO - Size 8 beam with a size 5 slot and three holes at the end.
//
// Between each beam is a connection that defines how the beams connect.
//
//  * Holes are numbered from 1 to N (the length of the beam) from left to right.
//  * Angles are in degrees.
//
//   [ PREVIOUS_BEAM_HOLE, CURRENT_BEAM_HOLE, ANGLE ]
//
// Here is a standard 4x2 90 degree lift arm:
//  
//   [ "XOOO", [ 4, 1, 90 ], [ "OO"] ]
//
// The connection hole specifier may includ a fractional part.
//
//
// Fractional Hole Spacing
//
// Here is a 4x2 beam with the size 2 beam in the midde of the size 4 beam.
// We use a space here so that we don't end up with a hole half way
// down the size 4 beam. 
//
// Connecing hole 2.5 of the size 4 beam to hole 1 of the size 2 beam at 90 degrees.
//
//   [ "OOOO", [ 2.5, 1, 90 ], " O" ]
//

hole_separation = 8.0;
hole_inside_diameter = 5.4;
stud_dia = 4.8;
hole_ring_dia = 6.28;
hole_ring_depth = 0.9;
beam_width = 7.6;
beam_height = 7.8;
axle_gap = 1.95;
axle_length = 5.1;
thin_beam_height = beam_height/3;

// beam143(5,5);

// anybeam( [ 
//  [ 5, "X<->O" ], 
//  [ 5, 1, 45 ], [ 5, "OOOOO" ], 
//  [ 5, 3, 90 ], [ 5, "XXOXX" ],
// ] );

anybeam_135x2();

//
// beams = [ beam, connection, beam, connection, ... beam ]
// beam = [ hole_count, hole_string  ] 
//

module anybeam( beams = [], height = beam_height ) {
  translate([0, 0, beam_height/2])
    difference() {
      _beams( 0, beams, height );
      _holes( 0, beams, height );
    }
}

module anybeam_tee( height = beam_height ) {
  anybeam( [ [3, "OOO"], [ 2, 1, 90 ], [ 3, "OOO" ] ], height );
}

module anybeam_143( left = [4, "XOOO"], right = [ 6, "OOOOOX" ], height = beam_height ) {
  anybeam( [ left, [ len(left[1]), 1, 53.13 ], right ], height );
}

module anybeam_90(left = [ 4, "XOOO" ], right = [ 2, "OO" ], height = beam_height) {
  anybeam( [ left, [ len(left[1]), 1, 90 ], right ], height );
}

module anybeam_135x2(left = [ 7, "XOOOOOO" ], middle = [ 4, " () " ], right = [ 3, "OOX" ], height = beam_height) {
  anybeam( [ left, [ len(left[1]), 1, 45 ], middle, [ len(middle[1]), 1, 45], right ], height );
}

module _holes( b = 0, beams = [], height = beam_height ) {
  beam = beams[b];
  connection = beams[b-1];
  next_beam = beams[b+2];


  if( connection ) {
    if( next_beam ) {
    translate( [ (connection[0]-1)*hole_separation, 0,  0 ] )
     rotate([0, 0, connection[2]])
      translate( [ -(connection[1]-1)*hole_separation, 0, 0 ] )
        cut_holes( beam, height )
          _holes( b+2, beams, height );          
    }
    else {
      translate( [ (connection[0]-1)*hole_separation, 0, 0 ] )
       rotate([0, 0, connection[2]])
        translate( [ -(connection[1]-1)*hole_separation, 0, 0 ] )
          cut_holes( beam, height );
    }
  }
  else {
    if( next_beam ) {
      cut_holes( beam, height )
        _holes( b+2, beams, height );            
    }
    else {
      cut_holes( beam, height );              
    }
  }
}

module _beams( b = 0, beams = [], height = beam_height ) {
  beam = beams[b];
  connection = beams[b-1];
  next_beam = beams[b+2];

  if( connection ) {
    if( next_beam ) {
    translate( [ (connection[0]-1)*hole_separation, 0, 0 ] )
     rotate([0, 0, connection[2]])
      translate( [ -(connection[1]-1)*hole_separation, 0, 0 ] )
        solid_beam( beam, height )
          _beams( b+2, beams, height );          
    }
    else {
      translate( [ (connection[0]-1)*hole_separation, 0, 0 ] )
       rotate([0, 0, connection[2]])
        translate( [ -(connection[1]-1)*hole_separation, 0, 0 ] )
          solid_beam( beam, height );
    }
  }
  else {
    if( next_beam ) {
      solid_beam( beam, height )
        _beams( b+2, beams, height );            
    }
    else {
      solid_beam( beam, height );              
    }
  }
}

module solid_beam( beam = [ 5, "OOOO" ], beam_height=7.8 ) {
  beam_length = (beam[0]-1)*hole_separation;
    union() {
      translate( [beam_length/2,0,0] ) {
      cube( [ beam_length, beam_width, beam_height ], center=true );

      translate( [-beam_length/2, 0, 0] )
        cylinder( r = beam_width/2, beam_height, center=true, $fn=100 );
      translate( [beam_length/2, 0, 0] )
        cylinder( r = beam_width/2, beam_height, center=true, $fn=100 );
      }

      if( $children ) children(0);
    }
}

module cut_holes( beam = [ 5, "OOOO" ], beam_height=7.8 ) {
  beam_length = (beam[0]-1)*hole_separation;
  holes = beam[0]-1;
  layout = beam[1];
    union() {
    translate( [beam_length/2,0,0] ) {

    for (hole = [0:1:holes]) {
        if( layout == "" ) {
          cut_hole( -beam_length/2+hole*hole_separation, beam_height );
        }
        else {
          if( layout[hole] == "O" ) {
            cut_hole( -beam_length/2+hole*hole_separation, beam_height );              
          } 
          if( layout[hole] == "(" ) {
            cut_left_slot( -beam_length/2+hole*hole_separation, beam_height );              
          } 
          if( layout[hole] == ")" ) {
            cut_right_slot( -beam_length/2+hole*hole_separation, beam_height );              
          } 
          if( layout[hole] == "X" ) {
            cut_axle( -beam_length/2+hole*hole_separation, beam_height, first = (hole==0), last = (hole==holes) );
          } 
          if( layout[hole] == "-" ) {
            cut_slot( -beam_length/2+hole*hole_separation, beam_height, first = (hole==0), last = (hole==holes) );
          } 
        }
    }
  }
    if( $children ) children(0);
  } 
}

module cut_left_slot(x,beam_height, first = false, last = false) {
  union() {
    cut_hole(x,beam_height);

    translate([x+hole_separation/4, 0, 0]) {
      cube([hole_separation/2+.05,hole_inside_diameter,beam_height+2], center = true);

      translate([0,0,beam_height/2-hole_ring_depth/2+.5])
        cube([hole_separation/2+0.05, hole_ring_dia, hole_ring_depth+1,], center = true);     

      translate([0,0,-(beam_height/2-hole_ring_depth/2+.5)])
        cube([hole_separation/2+0.05, hole_ring_dia, hole_ring_depth+1], center = true);     
    }  
  }
}

module cut_right_slot(x,beam_height, first = false, last = false) {
  cut_hole(x,beam_height);

  translate([x-hole_separation/4, 0, 0]) {
    cube([hole_separation/2+.05,hole_inside_diameter,beam_height+2], center = true);

    translate([0,0,beam_height/2-hole_ring_depth/2+.5])
      cube([hole_separation/2+0.05, hole_ring_dia, hole_ring_depth+1,], center = true);     

    translate([0,0,-(beam_height/2-hole_ring_depth/2+.5)])
      cube([hole_separation/2+0.05, hole_ring_dia, hole_ring_depth+1], center = true);     
  }  
}


module cut_slot(x,beam_height, first = false, last = false) {
  translate([x, 0, 0]) {
    cube([hole_separation,hole_inside_diameter,beam_height+2], center = true);

    translate([0,0,beam_height/2-hole_ring_depth/2+.5])
      cube([hole_separation, hole_ring_dia, hole_ring_depth+1,], center = true);     

    translate([0,0,-(beam_height/2-hole_ring_depth/2+.5)])
      cube([hole_separation, hole_ring_dia, hole_ring_depth+1], center = true);     
  }  
}

module cut_axle(x,beam_height, first = false, last = false) {
  translate([x, 0, 0]) {
    if( first == true ) {
      cube([axle_gap,axle_length,beam_height+2], center = true);
        translate([+.5,0,0])
        cube([axle_length+1,axle_gap,beam_height+2], center = true);    
    }
    if( last == true ) {
      cube([axle_gap,axle_length,beam_height+2], center = true);
        translate([-.5,0,0])
        cube([axle_length+1,axle_gap,beam_height+2], center = true);    
    }
    if( first == false && last == false ) {
      cube([axle_gap,axle_length,beam_height+2], center = true);
        cube([axle_length,axle_gap,beam_height+2], center = true);    
    }
  }
}

module cut_hole(x,beam_height) {
  union() {
  translate([x, 0, 0]) {
    cylinder(beam_height+2, hole_inside_diameter/2, hole_inside_diameter/2, center = true, $fn=100);

    translate([0,0,beam_height/2-hole_ring_depth/2+.5])
      cylinder(hole_ring_depth+1, hole_ring_dia/2, hole_ring_dia/2, center = true, $fn=100);     

    translate([0,0,-(beam_height/2-hole_ring_depth/2+.5)])
      difference() {
        cylinder(hole_ring_depth+1, hole_ring_dia/2, hole_ring_dia/2, center = true, $fn=100);
        cylinder(hole_ring_depth+1, hole_inside_diameter/2+.15, hole_inside_diameter/2+.15, center = true, $fn=100);
      }
  }    
  }
}