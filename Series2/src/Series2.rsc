module Series2

import IO;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import List;
import Set;
import Map;
import DateTime;
import util::Math;

import Normalize;
import Common;
import CloneDetection;
import Visualisation;

//public M3 project;
//public list[node] ast;

public void analyseProject(int cloneType) {
	println("---- START TIME ----");
	println(printTime(now(), "HH:mm:ss"));
	println("");
	
	project = getProjectFile(); //createM3FromEclipseProject(currentProject);
	ast = getProjectAST(); //createAstsFromEclipseProject(currentProject, true);
	
	clones = detectClones(cloneType, project, ast);
	for(<x,y> <- clones) {
		println("");
		println("");
		println("<x>");
		println("<y>");
		println("");
		println("");
	}
	
	biggestClone = getBiggestClone(clones);
	biggestCloneClass = getBiggestCloneClass(clones);

	println("------ STATS ------");
	println("	Duplicated lines <countDuplicateLines()/toReal(projectVolume(project))*100>%");
	println("	Number of clones: <size(clones)>");
	println("	Number of clone classes: <size(domain(cloneClasses(clones)))>");
	println("	biggest clone (in lines): <numberOfLines(biggestClone.l1)>");
	println("		<cloneClass(biggestClone.l1)> <biggestClone.l1.begin.line>-<biggestClone.l1.end.line>	<biggestClone.l1>");
	println("		<cloneClass(biggestClone.l2)> <biggestClone.l2.begin.line>-<biggestClone.l2.end.line>	<biggestClone.l2>");
	println("	biggest clone class: \"<biggestCloneClass>\" size: <cloneClasses(clones)[biggestCloneClass]>");
	println("------ END ------");
			
	println("");
	println(printTime(now(), "HH:mm:ss"));
	println("----  END TIME  ----");
	
	vis(project, clones);
}
