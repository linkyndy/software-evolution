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

public real similarityThreshold = 1.0;

public map[node, list[node]] buckets = ();

public list[tuple[node, node]] clones = [];


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
			}
		}
	}

	
	for (bucket <- buckets) {
		if (size(buckets[bucket]) < 2) continue;

		for (<x, y> <- combinations(buckets[bucket])) {
			//println("<x>, <y>");
			subtreeSimilarity = calculateSubtreeSimilarity(x, y);
			//println("<subtreeSimilarity> <similarityThreshold>");
			if (subtreeSimilarity >= similarityThreshold) {
				// Remove already added sub-clones
				visit (x) {
					case node n: {
						for (<c1, c2> <- clones) {
							if (c1 == n || c2 == n) {
								clones = delete(clones, indexOf(clones, <c1, c2>));
							}
						}
					}
				}
				visit (y) {
					case node n: {
						clones2 = clones;
						for (<c1, c2> <- clones) {
							if (c1 == n || c2 == n) {
								clones = delete(clones, indexOf(clones, <c1, c2>));
							}
						}
					}
				}
				// Add to clone list
				clones += <x, y>;
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

public lrel[node, node] combinations(list[node] nodes) {
	return [<nodes[i], nodes[j]> | i <- [0..(size(nodes) - 1)], j <- [(i+1)..(size(nodes))]];
 }
