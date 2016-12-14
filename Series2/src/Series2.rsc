module Series2

import IO;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import List;
import DateTime;

import Normalize;
import Common;

public int massThreshold = 5;

// Similarity values for which pairs of sub trees are eligible for the clone
// detection algorithm. Each type of clone has a different value
public map[int, real] similarityThreshold = (1: 1.0, 2: 1.0, 3: 0.5);

public map[node, list[node]] buckets = ();

// Store the associated mass for each sub tree. We need this in order to iterate
// over buckets in ascending order of their sub tree mass
public lrel[node, int] bucketMasses = [];

public list[tuple[loc, loc]] clones = [];


private int numberOfLines(node n) {
	location = getLocationOfNode(n);
	return location.end.line - location.begin.line;
}

public void analyseProject(int cloneType) {
	println("---- START TIME ----");
	println(printTime(now(), "HH:mm:ss"));
	println("");
	
	project = getProjectFile(); //createM3FromEclipseProject(currentProject);
	ast = getProjectAST(); //createAstsFromEclipseProject(currentProject, true);
	
	println("Analyzing project for clones of type <cloneType>");
	
	println("	Partitioning AST subtrees to buckets...");
	visit(ast) {
		case node x: {
			nodeMass = calculateNodeMass(x);
			if (nodeMass >= massThreshold) {
				if (cloneType in [2, 3]) {
					x = normalize(x);
				}
				if (buckets[x]?) {
					buckets[x] += x;
				} else {
					buckets[x] = [x];
				}
				bucketMasses += <x, nodeMass>;
			}
		}
	}

	println("	Sorting buckets by their subtree\'s node mass...");
	// Have a sorted list of buckets based on their sub tree mass
	bucketMasses = sort(bucketMasses, bool(tuple[node, int] a, tuple[node, int] b) { return a[1] < b[1]; });
	
	println("	Comparing AST subtrees from each bucket...");
	// Iterate over all sorted buckets and compare each bucket's subtrees for similarity
	for (<subTree, _> <- bucketMasses) {
		if (size(buckets[subTree]) < 2) continue;

		for (<x, y> <- combinations(buckets[subTree])) {
			//println("<x>, <y>");
			subtreeSimilarity = calculateSubtreeSimilarity(x, y);
			//println("<subtreeSimilarity> <similarityThreshold>");

			if (subtreeSimilarity >= similarityThreshold[cloneType]) {
				removeAlreadyAddedSubClones(x);
				removeAlreadyAddedSubClones(y);
				addClonePair(x, y);
			}
		}
	}

	//println(clones);

	println("	Detecting and grouping clone sequences... [skipped]");
	bool isItOk = true;
	while (!isItOk) {
		set[tuple[loc, loc]] pairsToBeDeleted = {};
		isItOk = true;
		for (<x, y> <- clones) {
			//println("X= <x>");
			<xStart, xEnd> = <x.begin.line, x.end.line>;
			<yStart, yEnd> = <y.begin.line, y.end.line>;

			// TODO: Skip pairs if their filename is different
			for (<z, t> <- clones, <z, t> != <x, y>) {
				//println("Z= <z>");
				<zStart, zEnd> = <z.begin.line, z.end.line>;
				<tStart, tEnd> = <t.begin.line, t.end.line>;

				if (zStart == xEnd + 1 && tStart == yEnd + 1) {
					// Remove individual clone pairs
					//clones = delete(clones, indexOf(clones, <x, y>));
					//clones = delete(clones, indexOf(clones, <z, t>));
					pairsToBeDeleted += {<x, y>, <z, t>};
					// Add sequence to list
					xzLocation = x;
					xzLocation.begin.line = xStart;
					xzLocation.end.line = zEnd;
					ytLocation = y;
					ytLocation.begin.line = yStart;
					ytLocation.end.line = tEnd;
					clones += <xzLocation, ytLocation>;
					isItOk = false;
					clones = clones - toList(pairsToBeDeleted);
					break;
				} else if (zEnd + 1 == xStart && tEnd + 1 == yStart) {
					// Remove individual clone pairs
					//clones = delete(clones, indexOf(clones, <x, y>));
					//clones = delete(clones, indexOf(clones, <z, t>));
					pairsToBeDeleted += {<x, y>, <z, t>};
					// Add sequence to list
					zxLocation = x;
					zxLocation.begin.line = zStart;
					zxLocation.end.line = xEnd;
					tyLocation = y;
					tyLocation.begin.line = tStart;
					tyLocation.end.line = yEnd;
					clones += <zxLocation, tyLocation>;
					isItOk = false;
					clones = clones - toList(pairsToBeDeleted);
					break;
				}
			}
		}
	}

	for(<x,y> <- clones) {
		println("");
		println("");
		println("<getLocationOfNode(x)>");
		println("<getLocationOfNode(y)>");
		println("");
		println("");
	}
			
	println("");
	println(printTime(now(), "HH:mm:ss"));
	println("----  END TIME  ----");
}

public loc getLocationOfNode(node subTree) {
	loc location = currentProject;

	if (Declaration d := subTree) {
		if (d@src?) {
			location = d@src;
		}
	} else if (Expression e := subTree) {
		if (e@src?) {
			location = e@src;
		}
	} else if (Statement s := subTree) {
		if (s@src?) {
			location = s@src;
		}
	}

	return location;
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
private real calculateSubtreeSimilarity(node x, node y) {
	list[node] xNodes = [];
	list[node] yNodes = [];

	visit(x) {
		case node n: xNodes += n;
	}
	visit(y) {
		case node n: yNodes += n;
	}

	s = size(xNodes & yNodes);
	l = size(xNodes - yNodes);
	r = size(yNodes - xNodes);
	
	return (2.0 * s) / (2 * s + l + r);
}

// Generate all combinations of two nodes from given input list
public lrel[node, node] combinations(list[node] nodes) {
	return [<nodes[i], nodes[j]> | i <- [0..(size(nodes) - 1)], j <- [(i+1)..(size(nodes))]];
}

// Remove sub clones of x that were already added to the clones list. Since we only care for clones,
// we are not interested in keeping sub clones of them also
private void removeAlreadyAddedSubClones(node x) {
	visit (x) {
		case node n: {
			for (<c1, c2> <- clones) {
				if (c1 == n || c2 == n) {
					clones = delete(clones, indexOf(clones, <c1, c2>));
				}
			}
		}
	}
}

private void addClonePair(node x, node y) {
	// TODO: if statement should be removed after fixing how the location is gotten for a node
	if (getLocationOfNode(x) != currentProject && getLocationOfNode(y) != currentProject) {
		clones += <getLocationOfNode(x), getLocationOfNode(y)>;
	}
}
