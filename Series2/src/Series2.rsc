module Series2


import IO;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;


import List;
import DateTime;

import Normalize;

public void analyseProject() {
	println("---- START TIME ----");
	println(printTime(now(), "HH:mm:ss"));
	println("");
	
	projectFile = |project://helloworld| ;
	// projectFile = |project://smallsql| ;
	// projectFile = |project://hsqldb| ;
	
	project = createM3FromEclipseProject(projectFile);
	ast = createAstsFromEclipseProject(projectFile, true);
	

	println("");
	println(printTime(now(), "HH:mm:ss"));
	println("----  END TIME  ----");
}