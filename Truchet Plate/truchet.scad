// Truchet tiles. Print equal numbers of pos and neg tiles 
// and see what you can create.

// What do you want to print?
// Enable plate below to do a whole plate with both.
// Use pair to get a pair for testing.
want = "pair"; // neg | pos | pair

// size of the tile
size = 20;
// total height of the tile
height = 8;
// thickness of the base relative to the total height
ratio = .5;

// Hide either the 'top' or 'bottom' of the tile.
// Useful for dual extrusion.
// Set to "none" to have the whole tile
hide = "none"; // none | top | bottom

//
// Plate Options
//
plate = 0; // 1 = generate a plate, 0 = don't
plate_size = 80;
separation = 5;
count = (plate_size + separation) / (size + separation);


if( plate == 1 ) {
	for ( x = [ 0 : count] ) {
		for ( y = [0 : count ] ) {
			if( round((x+y)/2) == (x+y)/2  ) {
				translate( [ x * (size+separation), y * (size+separation), 0]) {
					positive_tile();
				}				
			}
			if( round((x+y)/2) != (x+y)/2 ) {
				translate( [ x * (size+separation), y * (size+separation), 0]) {
					negative_tile();
				}				
			}
		}
	}
}
else {
if( want == "pair" ) {
	translate([size/2 + 5, 0, 0]) {
		positive_tile();
	}

	translate([-(size/2 + 5), 0, 0]) {
		negative_tile();
	}
}
if( want == "pos" && !plate) {
	positive_tile();
}

if( want == "neg" && !plate) {
	negative_tile();
}
}


module negative_tile() {
	translate([0, 0, height/2]) {
		if( hide == "top" ) {
			translate([0, 0, -height*ratio/2]) {
				cube(size=[size, size, height*ratio], center=true);										
			}
		}

		if( hide == "bottom") {
			difference() {
				translate([0, 0, height*(1-ratio)/2]) {
					cube(size=[size, size, height*(1-ratio)], center=true);
				}
				translate([-(size/2), -(size/2), height*ratio]) {
					cylinder(r=(size/2), h=height+2, center=true, $fn=100);	
				}
				translate([(size/2), (size/2), height*ratio]) {
					cylinder(r=(size/2), h=height+2, center=true, $fn=100);	
				}	
			}
		}

		if( hide == "none") {
			intersection() {
				cube(size=[size, size, height], center=true);				
				difference() {
					cube(size=[size, size, height], center=true);
					translate([-(size/2), -(size/2), height*ratio]) {
						cylinder(r=(size/2), h=height, center=true, $fn=100);	
					}
					translate([(size/2), (size/2), height*ratio]) {
						cylinder(r=(size/2), h=height, center=true, $fn=100);	
					}	
				}
			}					
		}
	}
}

module positive_tile() {
	translate([0, 0, height/2]) {
		if( hide == "top" ) {
			translate([0, 0, -height*ratio/2]) {
				cube(size=[size, size, height*ratio], center=true);										
			}
		}

		if( hide == "bottom") {
			intersection() {
				translate([0, 0, height*(1-ratio)/2]) {
					cube(size=[size, size, height*(1-ratio)], center=true);
				}
				union() {
					translate([-(size/2), -(size/2), 0]) {
						cylinder(r=(size/2), h=height, center=true, $fn=100);	
					}
					translate([(size/2), (size/2), 0]) {
						cylinder(r=(size/2), h=height, center=true, $fn=100);	
					}	
				}
			}

		}


		if( hide == "none") {
			intersection() {
				cube(size=[size, size, height], center=true);
				union() {
					translate([0, 0, -height*(1-ratio)]) {
						cube(size=[size, size, height], center=true);				
					}
					translate([-(size/2), -(size/2), 0]) {
						cylinder(r=(size/2), h=height, center=true, $fn=100);	
					}
					translate([(size/2), (size/2), 0]) {
						cylinder(r=(size/2), h=height, center=true, $fn=100);	
					}	
				}
			}

		}
	}
}
