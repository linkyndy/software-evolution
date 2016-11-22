package models;

public class Bus extends Vehicle{
	public Bus () {
		this.vehicleType = "Bus";
	}
	 
	public Integer getNumberOfWheels() {
		return 4;
	}
	public void justADuplicateMethod() {
		int a = 5;
		int b = 6;
		int c = a + b;
		int d;
		if (c == 10) {
			d = 1;
		}
	}
}
