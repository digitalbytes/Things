include <anybeam.scad>

// LEGO compatibile technic panels.

PANEL_WIDTH = 0;
PANEL_LENGTH = 0;

if( PANEL_WIDTH > 0 && PANEL_LENGTH > 0 ) {
	anypanel( width = PANEL_WIDTH, length = PANEL_LENGTH );	
}

module anypanel( width = PANEL_WIDTH, length = PANEL_LENGTH ) {
	difference() {
		ap_base( width, length );

		translate( [ 0, 0 ] )
			ab_holes( [ "O" ] );

		translate( [ AB_HOLE_SPACING * (width-1), 0, 0] )
			ab_holes( [ "O" ] );

		translate( [ AB_HOLE_SPACING * (width-1), AB_HOLE_SPACING * (length-3), ] )
			ab_holes( [ "O" ] );

		translate( [ 0, AB_HOLE_SPACING * (length-3) ] )
			ab_holes( [ "O" ] );

		translate( [ 0, AB_HOLE_SPACING ] )
			rotate( [ 0, 90, 0 ] )
				ab_holes( [ "O" ] );

		translate( [ AB_HOLE_SPACING * (width-1), AB_HOLE_SPACING, 0] )
			rotate( [ 0, 90, 0 ] )
				ab_holes( [ "O" ] );

		translate( [ AB_HOLE_SPACING * (width-1), AB_HOLE_SPACING * (length-4), ] )
			rotate( [ 0, 90, 0 ] )
				ab_holes( [ "O" ] );

		translate( [ 0, AB_HOLE_SPACING * (length-4) ] )
			rotate( [ 0, 90, 0 ] )
				ab_holes( [ "O" ] );
	}
}



module ap_base( width = 5, length = 11 ) {


	translate( [ 0, 0, 0  ] )
		anybeam_straight( 1 );

	translate( [ AB_HOLE_SPACING * (width-1), 0, 0] )
		anybeam_straight( 1 );

	translate( [ AB_HOLE_SPACING * (width-1), AB_HOLE_SPACING * (length-3), 0  ] )
		anybeam_straight( 1 );

	translate( [ 0, AB_HOLE_SPACING * (length-3), 0 ] )
		anybeam_straight( 1 );


	union() {
		translate( [ 0, -AB_HOLE_SPACING/2-2, -AB_BEAM_WIDTH/2 ] )
			cube( [ (width-1) * AB_HOLE_SPACING, (length-2) * AB_HOLE_SPACING+4, 1 ] );

		translate( [ 0, 0, 0 ] )
			ap_curved_support();

		translate( [ 0, AB_HOLE_SPACING*(length-3), 0 ] )
			ap_curved_support();

		translate( [ AB_HOLE_SPACING*(width-1), 0, 0 ] )
			rotate( [0,0,180] )
				ap_curved_support();

		translate( [ AB_HOLE_SPACING*(width-1), AB_HOLE_SPACING*(length-3), 0 ] )
			rotate( [0,0,180] )
				ap_curved_support();

	}

	translate( [ 0, -AB_HOLE_SPACING, 0] )
		rotate( [ -90, 0, 0 ] )
			trimmed_beam( width );

	translate( [ AB_HOLE_SPACING*1.5, -AB_HOLE_SPACING/2-2, -AB_BEAM_WIDTH/2 ] )
		rotate( [ 0, -90, 0 ] )
			ap_support();

	if( width > 4 ) {
		translate( [ AB_HOLE_SPACING*(width-2.5), -AB_BEAM_HEIGHT/2-2, -AB_BEAM_WIDTH/2 ] )
			rotate( [ 0, -90, 0 ] )
				ap_support();
    }

	translate( [ 0, (length - 2) * AB_HOLE_SPACING ] ) 
  	  rotate( [ 90, 0, 0 ] )
		trimmed_beam( width );

	translate( [ AB_HOLE_SPACING*1.5, AB_HOLE_SPACING*(length-2.5)+2, -AB_BEAM_WIDTH/2 ] )
		rotate( [ -180, -90, 0 ] )
			ap_support();

	if( width > 4 ) {
		translate( [ AB_HOLE_SPACING*(width-2.5), AB_HOLE_SPACING*(length-2.5)+2, -AB_BEAM_WIDTH/2 ] )
			rotate( [ -180, -90, 0 ] )
				ap_support();
    }

	translate( [0, AB_HOLE_SPACING, 0] )
		rotate( [ 90, 0, 90 ] )
			trimmed_beam( length - 4 );

	translate( [AB_HOLE_SPACING * (width-1), AB_HOLE_SPACING] )
		rotate( [ -90, 0, 90 ] )
				trimmed_beam( length - 4 );

	
}

module trimmed_beam( width = 5 ) {
	difference() {
		anybeam_straight( width );
		translate( [ AB_HOLE_SPACING * (width-1)/2, 0, AB_BEAM_HEIGHT/2-.45 ] )
			cube( [ AB_HOLE_SPACING * width, AB_BEAM_WIDTH+1, 1.1 ], center=true );
	}
}

module ap_curved_support() {
		rotate( [ 90,0, 0 ] )
		difference() {
		   cylinder(AB_BEAM_HEIGHT*2+1, AB_BEAM_WIDTH/2, AB_BEAM_WIDTH/2, $fn=100, center = true);
		   cylinder(AB_BEAM_HEIGHT*2+2, AB_HOLE_RING_DIAMETER/2, AB_HOLE_RING_DIAMETER/2, $fn=100, center = true );
			translate( [ -(AB_BEAM_WIDTH+2)/2, 0, -AB_BEAM_HEIGHT-1 ] )
				cube( [ AB_BEAM_WIDTH + 2, AB_BEAM_WIDTH + 2, AB_BEAM_HEIGHT*2+2 ] );
			translate( [ 0, -(AB_BEAM_WIDTH+2)/2, -AB_BEAM_HEIGHT-1 ] )
				cube( [ AB_BEAM_WIDTH + 2, AB_BEAM_WIDTH + 2, AB_BEAM_HEIGHT*2+2 ] );
		}
}


module ap_support() {
	translate( [0, 0, -.5] )
	difference() {
		cube( [ AB_BEAM_WIDTH, AB_BEAM_HEIGHT, 1 ] );
		translate( [AB_BEAM_HEIGHT, -1, -.1] ) 
			rotate( [ 0, 0, 45 ] )
				cube( [ AB_BEAM_WIDTH+1, AB_BEAM_HEIGHT*1.6, 1.2 ] );
	}

}