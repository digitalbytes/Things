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

beam_tee();

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

module beam_bent143(left = [4, "OOOX"], right = [ 6, "OOOOOX" ], height = beam_height ) {
  rotate([0,0,53.13])
    beam( right, height);
  rotate([0,0,180])
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

module beam( holes = [ 5, "OOOO" ], beam_height=7.8 ) {
  if( holes[0] ) {
    _beam( holes[0], beam_height, holes[1] );
  }
  else {
    _beam( holes, beam_height, "" );    
  }
}

module _beam( holes = 4, beam_height=7.8, layout = "", through_layout = "") {

  beam_length = hole_separation*(holes-1);

	translate( [beam_length/2,0,beam_height/2] ) {

	difference() {
  		union() {
  			cube( [ beam_length, beam_width, beam_height ], center=true );

  			translate( [-beam_length/2, 0, 0] )
  				cylinder( r = beam_width/2, beam_height, center=true, $fn=100 );
  			translate( [beam_length/2, 0, 0] )
  				cylinder( r = beam_width/2, beam_height, center=true, $fn=100 );
  		}

      for (hole = [0:1:holes]) {
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
  }
}

module cut_left_slot(x,beam_height, first = false, last = false) {
  cut_hole(x,beam_height);

  translate([x+hole_separation/4, 0, 0]) {
    cube([hole_separation/2+.05,hole_inside_diameter,beam_height+2], center = true);

    translate([0,0,beam_height/2-hole_ring_depth/2+.5])
      cube([hole_separation/2+0.05, hole_ring_dia, hole_ring_depth+1,], center = true);     

    translate([0,0,-(beam_height/2-hole_ring_depth/2+.5)])
      cube([hole_separation/2+0.05, hole_ring_dia, hole_ring_depth+1], center = true);     
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
