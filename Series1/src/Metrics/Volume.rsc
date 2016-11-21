module Metrics::Volume

import lang::java::jdt::m3::Core;
import Common;
import IO;
import List;
import String;
import Set;

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

public list[str] splitText(str text) = [ s | s <- split("\n", text), /^\s*$/ !:= s ];
