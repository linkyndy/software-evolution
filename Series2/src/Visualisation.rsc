module Visualisation

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import Relation;
import String;
import Map;
import List;
import Set;

import vis::Figure;
import vis::Render;

import IO;

import Common;

private M3 projectFile;
private list[loc] projectClasses;
public list[tuple[loc, loc]] clones = [];

public void vis(M3 project, list[tuple[loc,loc]] c) {
	projectFile = project;
	clones = c;
	projectClasses = getClasses(projectFile);


	i = hcat([classFigure(s) | s <- projectClasses], top());
	sc = hscreen(i,id("hscreen"));

	render(sc);
}

public Figure classFigure(loc projectClass) {
	textLabel = text(nameForLocation(projectClass));
	mFigure = methodsFigure(projectClass);
	
	row1 = [mFigure];
	row2 = [textLabel];
	
	return grid([row1, row2]);
}

public Figure methodsFigure(loc projectClass) {
	figures = [];
	for(method <- methodsFromClass(projectClass)) {
		if(hasClones(method.location)) {
			methodBox = box(text(method.name), fillColor("red"));
			figures += methodBox;
		} else {
			methodBox = box(text(method.name));
			figures += methodBox;
		}		
	}
	i = vcat(figures,top());
	sc = vscreen(i, vshrink(0.2));

	return sc;
}

public str nameForLocation(loc cl) {
	for(name <- projectFile@names) {
		if(name.qualifiedName == cl) {
			return name.simpleName;
		}
	}
	return "Undefined";
}

private bool hasClones(loc file) {
	//println("<nameForLocation(file)>");
	for(<x,y> <- clones) {
		//println("<file.begin.line> lt <x.begin.line> && <file.end.line> gt <x.end.line>");
		if(file.begin.line-1 <= x.begin.line && file.end.line+1 >= x.end.line) {
			return true;
		}
		//println("<file.begin.line> lt <y.begin.line> && <file.end.line> gt <y.end.line>");
		if(file.begin.line-1 <= y.begin.line && file.end.line+1 >= y.end.line) {
			return true;
		}
	}
	return false;
}

private bool showClass(loc class) {
	allCloneClasses = toList(domain(cloneClasses(clones)));
	return indexOf(allCloneClasses, cloneClass(class)) >= 0;
}
