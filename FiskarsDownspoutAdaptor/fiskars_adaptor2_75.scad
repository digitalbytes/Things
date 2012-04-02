use <roundCornersCube.scad>

wall = 3;

difference() {
	union() {
		roundedCube(73, 73, 50, 5);
		translate([0, 0, -24+(19/2)]) {
			roundedCube(102, 73, 21, 5);					
		}
	}

	roundedCube(70,70,60,5);

	translate([0, 0, -25+(19/2)-1.3]) {
		roundedCube(99,70,19,5);
	}
}

for ( i = [1 : 6] ) {
	translate([-50.3+i*3, 0, -25+(19/2)]) {
		cube(size=[.4, 70, 20], center=true);
	}
	translate([50.3-i*3, 0, -25+(19/2)]) {
		cube(size=[.4, 70, 20], center=true);
	}
}



module roundedCube(x,y,z,r) {
	union() {
	cube(size=[x, y-r*2, z], center=true);
	cube(size=[x-r*2, y, z], center=true);

	translate([x/2-r, y/2-r, 0]) {
		cylinder(r=r, h=z, center=true);					
	}

	translate([x/2-r, -(y/2-r), 0]) {
		cylinder(r=r, h=z, center=true);					
	}

	translate([-(x/2-r), -(y/2-r), 0]) {
		cylinder(r=r, h=z, center=true);					
	}

	translate([-(x/2-r), (y/2-r), 0]) {
		cylinder(r=r, h=z, center=true);					
	}		
	}
}


