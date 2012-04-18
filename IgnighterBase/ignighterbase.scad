difference() {
	cylinder(r=10.16, h=15.24, center=true, $fn=100);

	translate([0, 0, 2]) {
		cylinder(r=9.3, h=15.24, center=true, $fn=100);	
	}	

	translate([0, 0, -2]) {
		cylinder(r=7.62, h=15.24, center=true, $fn=100);	
	}	

}
