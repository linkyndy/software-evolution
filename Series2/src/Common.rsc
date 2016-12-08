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
public set[Declaration] getProjectAST() = createAstsFromEclipseProject(currentProject, true);

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