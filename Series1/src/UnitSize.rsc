module UnitSize

import lang::java::jdt::m3::Core;
import Common;
import Volume;
import IO;
import List;
import String;
import Set;
import util::Math;

public int unitSizeRating(M3 project) {
	methodRisks = methodsRisks(project);
	
	if(methodRisks.moderateRisk <= 25 && methodRisks.highRisk == 0 && methodRisks.veryHighRisk == 0) {
		return 5;
	} else if(methodRisks.moderateRisk <= 30 && methodRisks.highRisk == 5 && methodRisks.veryHighRisk == 0) {
		return 4;
	} else if(methodRisks.moderateRisk <= 40 && methodRisks.highRisk == 10 && methodRisks.veryHighRisk == 0) {
		return 3;
	} else if(methodRisks.moderateRisk <= 50 && methodRisks.highRisk == 15 && methodRisks.veryHighRisk == 5) {
		return 2;
	}
	return 1;
}

public list[int] locPerMethod(M3 project) = mapper(getMethods(project), locOfFile);

public tuple[real simpleRisk, real moderateRisk, real highRisk, real veryHighRisk] methodsRisks(M3 project) {
	totalVolume = projectVolume(project);
	simpleRisk = 0;
	moderateRisk = 0;
	highRisk = 0;
	veryHighRisk = 0;
	
	l = locPerMethod(project);
	for(m <- l) {
		if(m <= 10) {
			simpleRisk += m;
		} else if(m <= 20) {
			moderateRisk += m;
		} else if(m <= 50) {
			highRisk += m;
		} else {
			veryHighRisk += m;
		}
	}
	
	return <
			calculatePercentage(simpleRisk, totalVolume), 
			calculatePercentage(moderateRisk, totalVolume),
			calculatePercentage(highRisk, totalVolume),
			calculatePercentage(veryHighRisk, totalVolume)
			>;
}

private real calculatePercentage(int base, int total) = toReal(base)/toReal(total)*100;