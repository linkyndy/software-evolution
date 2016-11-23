module Metrics::Duplication

import IO;
import lang::java::jdt::m3::Core;
import List;
import Set;
import String;

import Common;

public int duplicationRating(real duplicationPercent) {
	if(duplicationPercent <= 3) {
		return 5;
	} else if(duplicationPercent <= 5) {
		return 4;
	} else if(duplicationPercent <= 10) {
		return 3;
	} else if(duplicationPercent <= 20) {
		return 2;
	}
	return 1;
}

public int projectDuplication(M3 project) {
	list[loc] locations = getMethods(project);
	list[lrel[str,int,loc]] blocks = [];

	for (location <- locations) {
		// Grab method's lines, without any surrounding whitespace
		list[str] lines = locOfFile(location);

		// Skip methods which have less than 6 lines
		if (size(lines) < 6) continue;

		// Form all possible blocks containing six consecutive lines from the current method,
		// together with their metadata (used to differentiate duplicate lines in the same
		// method or across different methods)
		lrel[str,int,loc] linesWithMetadata = zip(lines, index(lines), [location | _ <- upTill(size(lines))]);
		blocks += [[a,b,c,d,e,f] | [_*,a,b,c,d,e,f,_*] := linesWithMetadata];
	}

	rel[str,int,loc] duplicates = {};
	map[list[str], lrel[str,int,loc]] registry = ();

	for (block <- blocks) {
		lines = [line | <line,_,_> <- block];

		if (lines in registry) {
			// Add the current block's lines to the duplicate set...
			duplicates += {lineWithMetadata | lineWithMetadata <- block};
			// ...and also the initial block's lines whose duplicates are the above lines
			// NOTE: The initial block's lines may be added multiple times (i.e.: in case of a block being
			// 		 present in more than 3 places), but since this is a set, it doesn't matter
			duplicates += {initialLineWithMetadata | initialLineWithMetadata <- registry[lines]};
		} else {
			registry[lines] = block;
		}
	}

	return size(duplicates);
}
