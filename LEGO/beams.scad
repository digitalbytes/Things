//
// LEGO Beam Library
//
// This library provides a beam() module that can be used to create beams
// with a variaty of hole, axle and slot patterns. In addition it provides
// some standard LEGO beam parts for reference.
// 
// The holes, slots and axle holes are specified with a string. Each
// character in the string represents a hole, axle, slot or space.
//
//  O  Standard hole
//  X  Standard axle hole
//  <  Half width hole with a slot on the right.
//  >  Half width hole with the slot on the left.
//  -  A full width slot, use with <> to create long slots with rounded ends (e.g. <--->)
//  #  Skip this hole.
//
// Use the above symbols to represent the hole layout on the beam:
//
//   XOOOOX   - Size 6 beam with axle holes at the ends.
//   OOXOO    - Size 5 beam with an axle hole in the middle.
//   <--->OOO - Size 8 beam with a size 5 slot and three holes at the end.
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

lego_beam( [ 
        [ 5, "X<->O" ], 
        [ 5, 1, 45 ], [ 5, "OOOOO" ], 
        [ 5, 3, 90 ], [ 5, "XXOXX" ],
         ] );

//
// beams = [ beam, connection, beam, connection, ... beam ]
// beam = [ hole_count, hole_string  ] 
//

module lego_beam( beams = [], height = beam_height ) {
  translate([0, 0, beam_height/2])
    difference() {
      _beams( 0, 0, 0, 0, beams, height );
      _holes( 0, 0, 0, 0, beams, height );
    }
}

module _holes( b = 0, x = 0, y = 0, deg = 0, beams = [], height = beam_height ) {
  beam = beams[b];
  connection = beams[b-1];
  next_beam = beams[b+2];

  echo( beam );
  echo( connection );
  echo( next_beam );

  if( connection ) {
    if( next_beam ) {
    translate( [ (x+connection[0]-1)*hole_separation, y * hole_separation, 0 ] )
     rotate([0, 0, deg+connection[2]])
      translate( [ -(connection[1]-1)*hole_separation, 0, 0 ] )
        cut_holes( beam, height )
          _holes( b+2, x, y, deg, beams, height );          
    }
    else {
      translate( [ (x+connection[0]-1)*hole_separation, y * hole_separation, 0 ] )
       rotate([0, 0, deg+connection[2]])
        translate( [ -(connection[1]-1)*hole_separation, 0, 0 ] )
          cut_holes( beam, height );
    }
  }
  else {
    if( next_beam ) {
      cut_holes( beam, height )
        _holes( b+2, x, y, deg, beams, height );            
    }
    else {
      cut_holes( beam, height );              
    }
  }
}

module _beams( b = 0, x = 0, y = 0, deg = 0, beams = [], height = beam_height ) {
  beam = beams[b];
  connection = beams[b-1];
  next_beam = beams[b+2];

  echo( beam );
  echo( connection );
  echo( next_beam );

  if( connection ) {
    if( next_beam ) {
    translate( [ (x+connection[0]-1)*hole_separation, y * hole_separation, 0 ] )
     rotate([0, 0, deg+connection[2]])
      translate( [ -(connection[1]-1)*hole_separation, 0, 0 ] )
        solid_beam( beam, height )
          _beams( b+2, x, y, deg, beams, height );          
    }
    else {
      translate( [ (x+connection[0]-1)*hole_separation, y * hole_separation, 0 ] )
       rotate([0, 0, deg+connection[2]])
        translate( [ -(connection[1]-1)*hole_separation, 0, 0 ] )
          solid_beam( beam, height );
    }
  }
  else {
    if( next_beam ) {
      solid_beam( beam, height )
        _beams( b+2, x, y, deg, beams, height );            
    }
    else {
      solid_beam( beam, height );              
    }
  }
}

module beam_tee(stem = 3, cross = 3, height = beam_height) {
  rotate([0,0,90])
    beam( stem, height );

  if( cross[0] > 0 ) {
    translate([-(cross[0]-1)*hole_separation/2, 0, 0])
      beam( cross, height );    
  }
  else {
    translate([-(cross-1)*hole_separation/2, 0, 0])
      beam( cross, height );        
  }
}

module beam_bent143(left = [4, "XOOO"], right = [ 6, "OOOOOX" ], height = beam_height ) {
  translate([(left[0]-1)*hole_separation, 0, 0])    
    rotate([0,0,53.13])
      beam( right, height);
  beam( left, height);
}

module beam_bent90(left = [ 4, "OOOX" ], right = [ 2, "OO" ], height = beam_height) {
  rotate([0,0,90])
    beam( left, height );
    beam( right, height );  
}

module beam_tri(left = [ 7, "OOOOOOX" ], middle = [ 4, "O<>O" ], right = [ 3, "OOX" ], height = beam_height) {

  translate([-(cross-1)*hole_separation/2, 0, 0])  
    rotate([0,0,90]) beam(2);
      beam( holes = 4, height );
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
      echo( "cutting hole ", hole );
        if( layout == "" ) {
          cut_hole( -beam_length/2+hole*hole_separation, beam_height );
        }
        else {
          if( layout[hole] == "O" ) {
            cut_hole( -beam_length/2+hole*hole_separation, beam_height );              
          } 
          if( layout[hole] == "<" ) {
            cut_left_slot( -beam_length/2+hole*hole_separation, beam_height );              
          } 
          if( layout[hole] == ">" ) {
            cut_right_slot( -beam_length/2+hole*hole_separation, beam_height );              
          } 
          if( layout[hole] == "X" ) {
            cut_axle( -beam_length/2+hole*hole_separation, beam_height, first = (hole==0), last = (hole==holes-1) );
          } 
          if( layout[hole] == "-" ) {
            cut_slot( -beam_length/2+hole*hole_separation, beam_height, first = (hole==0), last = (hole==holes-1) );
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