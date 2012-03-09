function main(params) {

	var width = params.width;
	var radius = width/2;

	var frame = CSG.cube({
	  center: [0, 0, 0],
	  radius: [radius+3, radius+3, 3]
	});

	var inset = CSG.cube({
	  center: [0, 0, 2],
	  radius: [radius+.5, radius+.5, 3]
	});

	return frame.subtract(inset);
}

function getParameterDefinitions() {
	return [
	    {
	      name: 'width', 
	      type: 'float', 
	      default: 80,
	      caption: "Inside width of the frame:", 
	    }
    ];
}