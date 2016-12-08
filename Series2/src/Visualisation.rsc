module Visualisation

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import Relation;
import String;

import vis::Figure;
import vis::Render;

import IO;

import Common;

private M3 projectFile;
private list[loc] projectClasses;

public void vis() {
	projectFile = getProjectFile();
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
	str fileName = "<file>";
	if(size(fileName) % 2 == 0) {
		return true;
	}
	return false;
}
