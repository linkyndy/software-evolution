module Metrics::UnitComplexity

import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import Common;
import Metrics::Volume;
import IO;
import List;
import String;
import Set;

public int unitComplexityRating(tuple[real simpleRisk, real moderateRisk, real highRisk, real veryHighRisk] unitRisks) {	
	if(unitRisks.moderateRisk <= 25 && unitRisks.highRisk <= 0 && unitRisks.veryHighRisk <= 0) {
		return 5;
	} else if(unitRisks.moderateRisk <= 30 && unitRisks.highRisk <= 5 && unitRisks.veryHighRisk <= 0) {
		return 4;
	} else if(unitRisks.moderateRisk <= 40 && unitRisks.highRisk <= 10 && unitRisks.veryHighRisk <= 0) {
		return 3;
	} else if(unitRisks.moderateRisk <= 50 && unitRisks.highRisk <= 15 && unitRisks.veryHighRisk <= 5) {
		return 2;
	}
	return 1;
}

public tuple[real simpleRisk, real moderateRisk, real highRisk, real veryHighRisk] unitComplexityRisks(M3 project) {
	simpleRisk = 0;
	moderateRisk = 0;
	highRisk = 0;
	veryHighRisk = 0;
	
	l = complexityForProject(project);
	for(c <- l) {
		if(c.complexity <= 10) {
			simpleRisk += c.unitSize;
		} else if(c.complexity <= 20) {
			moderateRisk += c.unitSize;
		} else if(c.complexity <= 50) {
			highRisk += c.unitSize;
		} else {
			veryHighRisk += c.unitSize;
		}
	}
	
	totalVolume = simpleRisk + moderateRisk + highRisk + veryHighRisk;
	
	return <
			calculatePercentage(simpleRisk, totalVolume), 
			calculatePercentage(moderateRisk, totalVolume),
			calculatePercentage(highRisk, totalVolume),
			calculatePercentage(veryHighRisk, totalVolume)
			>;
}


public lrel[int complexity, int unitSize] complexityForProject(M3 project) {
	result = [];
	for(class <- getClasses(project)) {
		result += complexityPerClass(class);
	}
	return result;
}

public lrel[int, int] complexityPerClass(loc class) {
	ast = createAstFromFile(class, false);
	
	result = [];
	visit(ast) {
		case m:\constructor(_,_,_,_) :
			result += <complexityForMethod(m), locOfFile(m@src)>;
		case m:\method(_,_,_,_,_) :
			result += <complexityForMethod(m), locOfFile(m@src)>;
		case m:\method(_,_,_,_) :
			result += <complexityForMethod(m), locOfFile(m@src)>;
	};
	return result;
}

public int complexityForMethod(ast) {
	int cc = 1;
	
	visit(ast) {
		case \do(_,_) :
			cc += 1;
		case \foreach(_,_,_) :
			cc += 1;
		case \for(_,_,_,_) :
			cc += 1;
		case \for(_,_,_) :
			 cc += 1;
		case \if(_,_) :
			cc += 1;
		case \if(_,_,_) :
			cc += 1;
		case m:\case(_) : 
			cc += 1;
		case \while(_, _) :
			cc += 1;
		case \catch(_,_) :
			cc += 1;
		case \expressionStatement(_) : 
			cc += 1;
	}
	return cc;
}