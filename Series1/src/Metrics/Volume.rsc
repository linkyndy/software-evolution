module Metrics::Volume

import lang::java::jdt::m3::Core;
import List;
import Common;

public int volumeRating(int linesOfCode) {
	if(linesOfCode <= 66000) {
		return 5;
	} else if(linesOfCode <= 246000) {
		return 4;
	} else if(linesOfCode <= 665000) {
		return 3;
	} else if(linesOfCode <= 1310000) {
		return 2;
	}
	return 1;
}

public int projectVolume(M3 project) = sum(mapper(getClasses(project), countLocOfFile));
