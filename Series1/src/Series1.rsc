module Series1

import IO;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

import List;
import DateTime;

import Common;
import Metrics::Duplication;
import Metrics::Volume;
import Metrics::UnitSize;
import Metrics::UnitComplexity;

public void analyseProject() {
	println("---- START TIME ----");
	println(printTime(now(), "HH:mm:ss"));
	println("");
	
	project = getProjectModel();	
	
	
	println("---- Volume ----");
	volumeSize = projectVolume(project);
	println("Rating: <ratingToSymbol(volumeRating(volumeSize))> ");
	println("	Total LOC: <volumeSize> ");

	println("---- Unit Size ----");
	unitRisk = unitSizeRisks(project);
	println("Rating: <ratingToSymbol(unitSizeRating(unitRisk))>");
	println("	Simple Risk <unitRisk.simpleRisk>%");
	println("	Moderate Risk <unitRisk.moderateRisk>%");
	println("	High Risk <unitRisk.highRisk>%");
	println("	Very High Risk <unitRisk.veryHighRisk>%");
	
	
	println("---- Unit Complexity ----");
	unitComplexity = unitComplexityRisks(project);
	println("Rating: <ratingToSymbol(unitComplexityRating(unitComplexity))>");
	println("	Simple Risk <unitComplexity.simpleRisk>%");
	println("	Moderate Risk <unitComplexity.moderateRisk>%");
	println("	High Risk <unitComplexity.highRisk>%");
	println("	Very High Risk <unitComplexity.veryHighRisk>%");

	println("---- Duplication ----");
	duplicateLines = projectDuplication(project);
	duplicatePercentage = calculatePercentage(duplicateLines, volumeSize);
	println("Rating: <ratingToSymbol(duplicationRating(duplicatePercentage))> ");
	println("	Duplicate LOC: <duplicateLines> ");
	println("	Total LOC: <volumeSize> ");
	println("	Duplication percentage: <duplicatePercentage>% ");

	println("");

	// Bigger size units are significantly harder to analyze than smaller ones. Then, the total number of loc plays a secondary role.
	// Duplication doesn't influence analysability that much since it sometimes is easier when you see the whole chunk of code instead
	// of a factored out method
	analysability = volumeRating(volumeSize) * 0.3 + duplicationRating(duplicatePercentage) * 0.1 + unitSizeRating(unitRisk) * 0.6;
	// A complex unit is harder to change than a concise one. Duplication plays a secondary role, since it makes it time consuming
	// to apply the same changes in several places
	changeability = unitComplexityRating(unitComplexity) * 0.65 + duplicationRating(duplicatePercentage) * 0.35;
	// A complex unit is hard to test. A unit that is bigger is also significantly harder to test, but still not as hard as a complex one
	testability = unitComplexityRating(unitComplexity) * 0.6 + unitSizeRating(unitRisk) * 0.4;
	// In order to maintain a particular piece of code, you first need to be able to analyze and understand it. Equally important is the
	// easiness of changing that code. You cannot change code that can't be analyze and it's also meaningless to properly analyze code
	// but to be impossible to change it. Testability plays a quite smaller role here, although not one to be neglected. Code _can_ be
	// maintained without tests, but that is definitely easier with a good test coverage
	maintainability = analysability * 0.4 + changeability * 0.4 + testability * 0.2;

	println("Maintainability (overall): <ratingToSymbol(maintainability)>");
	println("Analysability: <ratingToSymbol(analysability)>");
	println("Changeability: <ratingToSymbol(changeability)>");
	println("Testability: <ratingToSymbol(testability)>");

	println("");
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