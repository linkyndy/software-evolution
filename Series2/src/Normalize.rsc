module Normalize

import analysis::m3::AST;

public node normalize(node ast) {
	return visit (ast) {
		case \method(x, _, y, z, q) => \method(lang::java::jdt::m3::AST::short(), "method", y, z, q)
		case \method(x, _, y, z) => \method(lang::java::jdt::m3::AST::short(), "method", y, z)
		case \parameter(x, _, z) => \parameter(x, "parameter", z)
		case \vararg(x, _) => \vararg(x, "vararg") 
		case \annotationTypeMember(x, _) => \annotationTypeMember(x, "annotationTypeMember")
		case \annotationTypeMember(x, _, y) => \annotationTypeMember(x, "annotationTypeMember", y)
		case \typeParameter(_, x) => \typeParameter("typeParameter", x)
		case \constructor(_, x, y, z) => \constructor("constructor", x, y, z)
		case \interface(_, x, y, z) => \interface("interface", x, y, z)
		case \class(_, x, y, z) => \class("class", x, y, z)
		case \enumConstant(_, y) => \enumConstant("enumConstant", y) 
		case \enumConstant(_, y, z) => \enumConstant("enumConstant", y, z)
		case \methodCall(x, _, z) => \methodCall(x, "methodCall", z)
		case \methodCall(x, y, _, z) => \methodCall(x, y, "methodCall", z) 
		case Type _ => lang::java::jdt::m3::AST::short()
		case Modifier _ => lang::java::jdt::m3::AST::\private()
		case \simpleName(_) => \simpleName("simpleName")
		case \number(_) => \number("1")
		case \variable(x,y) => \variable("variable",y) 
		case \variable(x,y,z) => \variable("variable",y,z) 
		case \booleanLiteral(_) => \booleanLiteral(true)
		case \stringLiteral(_) => \stringLiteral("stringLiteral")
		case \characterLiteral(_) => \characterLiteral("a")
	}
}