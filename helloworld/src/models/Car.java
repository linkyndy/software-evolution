package models;

public class Car extends Vehicle{
	public Car () {
		this.vehicleType = "Car";
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
