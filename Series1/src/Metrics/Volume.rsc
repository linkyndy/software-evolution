module Metrics::Volume

import lang::java::jdt::m3::Core;
import Common;
import IO;
import List;
import String;
import Set;

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

public int projectVolume(M3 project) = sum(mapper(getClasses(project), locOfFile));

public int locOfFile(loc file) {
	plainText = fileContent(file);
	return locOfString(plainText);
}

public int locOfString(str plainText) {
	withoutComments = removeComments(plainText);	
	listText = splitText(withoutComments);
	return size(listText);
}

public str removeComments(str text) {
	return visit(text) {
		case /\/\*.*?\*\//s => "" // multi line comments
		case /\/\/.*/ => "" // single line comments
	}
}

public list[str] splitText(str text) = [ s | s <- split("\n", text), s != "", /^\s*$/ !:= s ];