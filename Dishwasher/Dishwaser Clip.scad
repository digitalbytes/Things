rotate([0, 0, 0]) {
difference() {
	
	union() {

		cube(size=[16, 10, 18], center=true);
//		cylinder(r=10, h=18, center=true);
	
		translate([0, 0, -7]) {
			rotate([0, 90, 0]) {
				cylinder(r=4.2, h=46, center=true);			
			}			
		}
		

	}

	translate([3, 0, 0]) {
		cylinder(r=3, h=22, center=true);		
	}

	translate([0, 0, -9]) {
		translate([0, 0, 10]) {
			rotate([90,0, 0]) {
				cylinder(r=2, h=25, center=true, $fn = 50);			
			}					
		}
		cube(size=[4, 22, 20], center=true);		
	}


	translate([0, 0, -11]) {
		translate([0, 0, 4]) {
			rotate([0,90, 0]) {
				cylinder(r=2.2, h=60, center=true, $fn = 50);			
			}					
		}
//		cube(size=[60, 4, 8], center=true);			
	}

	translate([0, 0, -11.28]) {
		cube(size=[90, 90, 5], center=true);		
	}

}	
}




