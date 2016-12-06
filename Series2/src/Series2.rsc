module Series2

import IO;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;


import List;
import DateTime;

import Normalize;

public int massThreshold = 5;

public int similarityThreshold = 10;

public map[str, list[node]] buckets = ();

public void analyseProject(int cloneType) {
	println("---- START TIME ----");
	println(printTime(now(), "HH:mm:ss"));
	println("");
	
	projectFile = |project://helloworld| ;
	// projectFile = |project://smallsql| ;
	// projectFile = |project://hsqldb| ;
	
	project = createM3FromEclipseProject(projectFile);
	ast = createAstsFromEclipseProject(projectFile, true);
	
	//println(ast);
	println("Analyzing project for clones of type <cloneType>");
	
	println("	Partitioning AST subtrees to buckets...");
	visit(ast) {
		case node x: {
			nodeMass = calculateNodeMass(x);
			if (nodeMass >= massThreshold) {
				if (cloneType in [2, 3]) {
					// Normalize node
				}
				// Add node to bucket
			}
		}
	}
	
	println("	Comparing AST subtrees from each bucket...");
	for (bucket <- buckets) {
		// for each tuple of 2 nodes from current bucket {
			subtreeSimilarity = calculateSubtreeSimilarity(x, y);
			if (subtreeSimilarity >= similarityThreshold) {
				// Add to clone list
				// Remove already added sub-clones
			}
		// }
	}
			
	println("");
	println(printTime(now(), "HH:mm:ss"));
	println("----  END TIME  ----");
}

// Determine the number of nodes present in AST subtree with root x
private int calculateNodeMass(node x) {
	int mass = 0;
	visit(x) {
		case node _: mass += 1;
	}
	return mass;
}

// Determine the similarity between two AST subtrees
private int calculateSubtreeSimilarity(node x, node y) {
	return 0;
}
