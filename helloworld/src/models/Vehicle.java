package models;

public abstract class Vehicle {	
	public String vehicleType;
	
	/* Multi line comments
	 * New line
	 */
	public Integer getNumberOfSeats()
	{
		if (this.vehicleType.equals("Car")) {
			return 5;
		} else if (this.vehicleType.equals("Bus")) {
			return 20;
		} else if (this.vehicleType.equals("Motorcycle")) {
			return 1;
		}
		return null;
	}
	//Single line comments
	public String getVehicleType()  {
		return this.vehicleType;
	}
	 
	public abstract Integer getNumberOfWheels();
}
