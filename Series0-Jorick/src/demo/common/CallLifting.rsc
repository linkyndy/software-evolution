module demo::common::CallLifting

alias proc = str;
alias comp = str;

public rel[comp, comp] lift(rel[proc, proc] aCalls, rel[proc, comp] aPartOf) {
	return { <c1, c2> | <proc p1, proc p2> <- aCalls, <comp c1, comp c2> <- aPartOf[p1]*aPartOf[p2] };
}