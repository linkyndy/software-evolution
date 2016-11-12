module Test

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;

public M3 getModel() {
	
	myModel = createM3FromEclipseProject(|project://helloworld|);
	
	//return myModel;
	names = myModel@names;
	
	return myModel;
	
	//myModel@methodInvocation(|path|);
	//myModel@methodInvocation<to,from>(|path|);
}

public lrel[str simpleName, loc qualifiedName] getClasses(model) {
	return [c | c <- model@names, bprintln(c.qualifiedName), c.scheme == "java+class"];
}

//public loc getClassFromMethod(M3 model, loc method) { 
//	return model@containment[
//}

public list[loc] getMethodsFromClass(M3 model, loc class) {
	return [ e | e <- model@containment[class], e.scheme == "java+method"];
}

public lrel[loc from, loc to] getCallsFrom(M3 model, loc path) {
	return [c | c <- model@methodInvocation, bprintln(c.from), bprintln(path), c.from == path];
}