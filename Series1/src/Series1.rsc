module Series1

import IO;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

import List;
import DateTime;

import Common;
import Metrics::Volume;
import Metrics::UnitSize;
import Metrics::UnitComplexity;

public void analyseProject() {
	println("---- START TIME ----");
	println(printTime(now(), "HH:mm:ss"));
	println("----  END TIME  ----");
	println("");
	
	project = getProjectModel();	
	
	
	println("---- Volume ----");
	volumeSize = projectVolume(project);
	println("Total LOC: <volumeSize> ");
	println("Rating: <volumeRating(volumeSize)> ");
	
	println("---- Unit Size ----");
	unitRisk = unitSizeRisks(project);
	println("Rating: <unitSizeRating(unitRisk)>");
	println("	Simple Risk <unitRisk.simpleRisk>%");
	println("	Moderate Risk <unitRisk.moderateRisk>%");
	println("	High Risk <unitRisk.highRisk>%");
	println("	Very High Risk <unitRisk.veryHighRisk>%");
	
	
	println("---- Unit Complexity ----");
	unitComplexity = unitComplexityRisks(project);
	println("Rating: <unitComplexityRating(unitComplexity)>");
	println("	Simple Risk <unitComplexity.simpleRisk>%");
	println("	Moderate Risk <unitComplexity.moderateRisk>%");
	println("	High Risk <unitComplexity.highRisk>%");
	println("	Very High Risk <unitComplexity.veryHighRisk>%");
	
	println("---- Clone Detection ----");
	
	println("");
	println("---- START TIME ----");
	println(printTime(now(), "HH:mm:ss"));
	println("----  END TIME  ----");
}

public M3 getProjectModel() {
	// projectFile = |project://helloworld| ;
	// projectFile = |project://smallsql| ;
	projectFile = |project://hsqldb| ; 
	model = createM3FromEclipseProject(projectFile);
	return model;
}