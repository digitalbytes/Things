id = 27.178;
od = 30.734;

ecd = 15.24;

difference() {
	cylinder(r=od/2, h=13, center=true, $fn=100);

	translate([0, 0, 2]) {
		cylinder(r=id/2, h=13, center=true, $fn=100);	
	}	

	translate([0, 0, -2]) {
		cylinder(r=ecd/2, h=13, center=true, $fn=100);	
	}	

}
