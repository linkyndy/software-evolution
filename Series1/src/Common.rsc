module Common

import lang::java::jdt::m3::Core;
import List;
import Set;
import IO;
import util::Math;

public M3 getModel() {
	projectFile = |project://helloworld| ;
	myModel = createM3FromEclipseProject(projectFile);
	return myModel;
}

public list[loc] getClasses(M3 project) = toList(classes(project));
public int countClasses(M3 project) = size(getClasses(project));

public list[loc] getMethods(M3 project) = toList(methods(project));
public int countMethods(M3 project) = size(getMethods(project));

public str fileContent(loc file) = readFile(file);

public real calculatePercentage(int base, int total) = toReal(base)/toReal(total)*100;