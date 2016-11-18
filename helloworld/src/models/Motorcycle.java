package models;

public class Motorcycle extends Vehicle {
	public Motorcycle () {
		this.vehicleType = "Motorcycle";
	}
	 
	public Integer getNumberOfWheels() {
		return 1;
	}
}
