package models;

public class Bus extends Vehicle{
	public Bus () {
		this.vehicleType = "Bus";
	}
	 
	public Integer getNumberOfWheels() {
		return 4;
	}
}
