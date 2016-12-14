module Normalize

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::m3::AST;

public node normalize(node ast) {
	return visit(ast) {
	//Declaration
    	//case \enum(_, x, y, z) => \enum("enum", x, y, z)
    	//case \enumConstant(_, x, y) => \enum("enum", x, y)
    	//case \enumConstant(_, x) => \enumConstant("enum", x)
    	//case \class(_, x, y, z) => \class("class", x, y, z)
    	//case \interface(_, x, y, z) => \interface("interface", x, y, z)
		case \method(x, _, y, z, q) => \method(x, "method", y, z, q)
		case \method(x, _, y, z) => \method(x, "method", y, z)
    	//case \constructor(_, x, y, z) => \constructor("constructor", x, y, z)
    	//case \import(_) => \import("import")
    	//case \package(_) => \package("package")
    	//case \package(x, _) => \package(x, "package")
    	//case \typeParameter(_, x) => \typeParameter("typeParameter", x)
		//case \annotationType(_, x) => \annotationType("annotationType", x)
		//case \annotationTypeMember(x, _) => \annotationTypeMember(x, "annotationTypeMember")
		//case \annotationTypeMember(x, _, y) => \annotationTypeMember(x, "annotationTypeMember", y) 
		//case \parameter(x, _, y) => \parameter(x, "parameter", y)
		//case \vararg(x, _) => \vararg(x, "vararg")
	//Expression    	
    	case \characterLiteral(_) => characterLiteral("characterLiteral")
    	//case \fieldAccess(x, y, _) => fieldAccess(x, y, "fieldAccess")
    	//case \fieldAccess(x, _) => fieldAccess(x, "fieldAccess")
    	//case \methodCall(x, _, y) => \methodCall(x, "methodCall", y)
    	//case \methodCall(x, y, _, z) => \methodCall(x, y, "methodCall", z)
    	case \number(_) => \number("1")
    	case \booleanLiteral(_) => \booleanLiteral(true)
    	case \stringLiteral(_) => \stringLiteral("stringLiteral")
    	case \variable(_, x) => \variable("variable", x)
    	case \variable(_, x, y) => \variable("variable", x, y)
    	case \simpleName(_) => \simpleName("simpleName")
    	//case \markerAnnotation(_) => \markerAnnotation("markerAnnotation")
    	//case \normalAnnotation(_, x) => \normalAnnotation("normalAnnotation", x)
		//case \memberValuePair(_, x) => \memberValuePair("memberValuePair", x)
		//case \singleMemberAnnotation(_, x) => \singleMemberAnnotation("singleMemberAnnotation", x)
		//case Type _ => lang::java::jdt::m3::AST::short()
		//case Modifier _ => lang::java::jdt::m3::AST::\private()	
	}
}