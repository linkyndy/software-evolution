module Metrics::Volume

import lang::java::jdt::m3::Core;
import List;
import Common;

public str volumeRating(int linesOfCode) {
	if(linesOfCode <= 66000) {
		return "++";
	} else if(linesOfCode <= 246000) {
		return "+";
	} else if(linesOfCode <= 665000) {
		return "o";
	} else if(linesOfCode <= 1310000) {
		return "-";
	}
	return "--";
}

public int projectVolume(M3 project) = sum(mapper(getClasses(project), countLocOfFile));
