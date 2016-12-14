module Common

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;


import List;
import Set;
import String;
import IO;
import util::Math;

public loc currentProject = |project://helloworld|;
//public loc currentProject = |project://smallsql|;
//public loc currentProject = |project://hsqldb|;

public M3 getProjectFile() = createM3FromEclipseProject(currentProject);
public set[Declaration] getProjectAST() = createAstsFromEclipseProject(currentProject, false);

public list[loc] getClasses(M3 project) = toList(classes(project));
public int countClasses(M3 project) = size(getClasses(project));

public list[loc] getMethods(M3 project) = toList(methods(project));
public int countMethods(M3 project) = size(getMethods(project));


public lrel[str name, loc location] methodsFromClass(loc class) {
	ast = createAstFromFile(class, false);
	
	result = [];
	visit(ast) {
		case m:\constructor(_,_,_,_) :
			result += <"constructor", m@src>;
		case m:\method(_,n,_,_,_) :
			result += <n, m@src>;
		case m:\method(_,n,_,_) :
			result += <n, m@src>;
	};
	return result;
}

public list[str] locOfFile(loc file) {
	plainText = fileContent(file);
	withoutComments = removeComments(plainText);
	listText = splitText(withoutComments);
	return listText;
}
public int countLocOfFile(loc file) = size(locOfFile(file));
public str fileContent(loc file) = readFile(file);

private list[str] splitText(str text) = [ s | s <- split("\n", text), /^\s*$/ !:= s ];

private str removeComments(str text) {
	return visit(text) {
		case /\/\*.*?\*\//s => "" // multi line comments
		case /\/\/.*/ => "" // single line comments
	}
}

public int projectVolume(M3 project) = sum(mapper(getClasses(project), countLocOfFile));

public int numberOfLines(loc location) {
	return location.end.line - location.begin.line;
}


public map[str, int] cloneClasses(list[tuple[loc, loc]] clones) {
	list[str] classes = [];
	for(<x,y> <- clones) {
		classes += cloneClass(x);
		classes += cloneClass(y); 
	}
	dist = distribution(classes);
	return dist;
}
public str cloneClass(loc location) {
	return head(split(".", location.file));
}
public str getBiggestCloneClass(list[tuple[loc, loc]] clones) {
	str biggest = "";
	int size = 0;
	for(<x,y> <- clones) {
		if(numberOfLines(x) > size) {
			biggest = cloneClass(x);
		}
	}
	return biggest;
}
public tuple[loc l1, loc l2] getBiggestClone(list[tuple[loc,loc]] clones) {
	tuple[loc,loc] biggest;
	int size = 0;
	for(<x,y> <- clones) {
		if(numberOfLines(x) > size) {
			biggest = <x,y>;
		}
	}
	return biggest;	
}