lego_w = 7.8;
lego_h = 9.6;

rotate([0, 180, 0]) {
	

difference() {
	cube(size=[18.4, 27, 9]);

 	translate([5, 21.5-8, -5]) {
		rotate([90, 0, 0]) {
			axle(length=50);	 		 		
	 	}
	 }

 	translate([5, 21.5-16, -5]) {
		rotate([90, 0, 0]) {
			axle(length=50);	 		 		
	 	}
	 }

 	translate([5, 21.5, -5]) {
		rotate([90, 0, 0]) {
			axle(length=50);	 		 		
	 	}
	 }

 	translate([13, 21.5, -5]) {
		rotate([90, 0, 0]) {
			axle(length=50);	 		 		
	 	}
	 }

 	translate([10.5, -1, -1]) {
		cube(size=[5, 17, 12]);
	}

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

