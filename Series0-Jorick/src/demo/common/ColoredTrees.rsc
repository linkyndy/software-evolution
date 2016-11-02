module demo::common::ColoredTrees

data ColoredTree = leaf(int N)
				| red(ColoredTree left, ColoredTree right)
				| black(ColoredTree left, ColoredTree right);

public int cntRed(ColoredTree t) {
	int c = 0;
	visit(t) {
		case red(_,_): c = c+1;
	}
	return c;
}

public int cntBlack(ColoredTree t) {
	int c = 0;
	visit(t) {
		case black(_,_): c = c+1;
	}
	return c;
}

public int addLeaves(ColoredTree t) {
	int c = 0;
	visit(t) {
		case leaf(int N): c = c + N;
	}
	return c;
}

data ColoredTree = green(ColoredTree left, ColoredTree right);

public ColoredTree makeGreen(ColoredTree t) {
	return visit(t) {
		case red(l,r) => green(l, r)
	};
}