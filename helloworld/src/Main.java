import static java.lang.System.out;

import models.*;

public class Main {

	public static void main(String [] args)
	{
		
		Bus bus = new Bus();
		Car car = new Car();
		Motorcycle motorcyle = new Motorcycle();
		
		System.out.println(bus.getVehicleType() + " number of seats " + bus.getNumberOfSeats());
		System.out.println(car.getVehicleType() + " number of seats " + car.getNumberOfSeats());
		System.out.println(motorcyle.getVehicleType() + " number of seats " + motorcyle.getNumberOfSeats());
	}
		
}
