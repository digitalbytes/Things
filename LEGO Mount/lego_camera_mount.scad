lego_w = 7.8;
lego_h = 9.6;


translate([5, 13.75, 12.5]) {
	
difference() 
{
	union() {
		rotate([90, 0, 0]) {
			cylinder(r=3.25, h=27.5, center=true, $fn=100);
		}	
		translate([0, 0, -2]) {
			cube(size=[6.5, 27.5, 4], center=true);
		}
	}
	rotate([90, 0, 0]) {
		cylinder(r=3.5, h=7, center=true, $fn=100);
	}
	translate([0, 0, 0]) {
		cube(size=[7, 7, 6], center=true);
	}

	translate([0, 1.3, 1.4]) {
	rotate([-5, 0, 0]) {
		cube(size=[7, 5.2, 8], center=true);
	}
	}

	translate([0, -1.3, 1.4]) {
		rotate([5, 0, 0]) {
			cube(size=[7, 5.2, 8], center=true);
		}
	}


	rotate([90, 0, 0]) {
		cylinder(r=1.5785, h=28, center=true, $fn=100);
	}			

	translate([0, -10, 0]) {
		rotate([90, 0, 0]) {
			intersection() {
				cylinder(r=2.1, h=14, center=true, $fn=100);
				cube(size=[10, 3.157, 14], center = true);
			}
		}	
		
	}

}
}


difference() {
	cube(size=[10, 27.5, 9]);

 	translate([5, 21.5-8, -5]) {
		rotate([90, 0, 0]) {
			axle(length=50);	 		 		
	 	}
	 }

 	translate([5, 21.5-16, -4]) {
		rotate([90, 0, 0]) {
			axle(length=48);	 		 		
	 	}
	 }

 	translate([5, 21.5, -4]) {
		rotate([90, 0, 0]) {
			axle(length=48);	 		 		
	 	}
	 }

 	translate([13, 21.5, -4]) {
		rotate([90, 0, 0]) {
			axle(length=50);	 		 		
	 	}
	 }

 	translate([10.5, -1, -1]) {
		cube(size=[5, 17, 12]);
	}

}

module axle(length) {
	translate([-1.9/2, 0,  -4.9/2]) {
		cube(size=[1.9, length, 4.9]);		
	}

	translate([-4.9/2, 0, -1.9/2]) {
		cube(size=[4.9, length, 1.9]);	
	}
}

