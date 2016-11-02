module demo::basic::Squares

import IO;

public void squares(int N) {
	println("Table of squares from 1 to <N>");
for (int I <- [1 .. N+1]) {
		println("<I> squared = <I * I>");
	}
}

public str squaresTemplate(int N) 
  = "Table of squares from 1 to <N>
	'<for (int I <- [1 .. N + 1]) {>
    '  <I> squared = <I * I><}>
    ";