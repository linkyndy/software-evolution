package models;

public class Car extends Vehicle{
	public Car () {
		this.vehicleType = "Car";
	}
	 
	public Integer getNumberOfWheels() {
		return 4;
	}
	
}
