module demo::basic::Even

list[int] even0(int max) {
	list[int] result = [];
	for (int i <- [0..max]) {
		if (i%2==0) {
			result += i;
		}
	}
	return result;
}

list[int] even1(int max) {
	result = [];
	for (int i <- [0..max]) {
		if (i%2==0) {
			result += i;
		}
	}
	return result;
}

list[int] even2(int max) {
	result = for (int i <- [0..max]) {
		if (i%2==0) {
			append i;
		}
	}
	return result;
}

list[int] even3(int max) {
	return for (int i <- [0..max]) {
		if(i%2==0) {
			append i;
		}
	}
}

list[int] even4(int max) {
	return [i | i <- [0..max], i%2==0];
}

list[int] even5(int max) = [i | i <- [0..max], i%2==0];

set[int] even6(int max) = {i | i <- [0..max], i%2==0 };
