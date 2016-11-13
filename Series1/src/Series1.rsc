module Series1

import IO;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

import List;

import Volume;
import Common;
import UnitSize;


public void analyseProject() {
	project = getProjectModel();	
	
	println("---- Volume ----");
	println("Total LOC: <projectVolume(project)> ");
	println("Rating: <volumeRating(project)> ");
	
	println("---- Unit Size ----");
	println("Rating: <unitSizeRating(project)>");
	
}

public M3 getProjectModel() {
	projectFile = |project://helloworld| ;
	// projectFile = |project://smallsql| ;
	// projectFile = |project://hsqldb| ;
	model = createM3FromEclipseProject(projectFile);
	return model;
}