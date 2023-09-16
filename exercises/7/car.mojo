struct Car:
    var brand: String
    var model: String
    var year: Int
    var price: Float64

    fn __init__(inout self, brand: String):
        """Car with only brand."""
        self.brand = brand
        self.model = 'Base'
        self.year = 0
        self.price = 0.0

    fn __init__(inout self, brand: String, model: String, year: Int, price: Float64):
        """Car with brand and model."""
        self.brand = brand
        self.model = model
        self.year = year
        self.price = price

    fn print_car_details(self):
        print("Make:", self.brand)
        print("Model:", self.model)
        print("Year:", self.year)
        print("Price:", self.price)

fn main():
    # Create car instances
    let car1 = Car("Toyota", "Corolla", 2023, 25000.0)
    let car2 = Car("Honda", "Civic", 2013, 28000.0)

    # Print car details
    car1.print_car_details()
    car2.print_car_details()
# =>
# Make: Toyota
# Model: Corolla
# Year: 2023
# Price: 25000.0
# Make: Honda
# Model: Civic
# Year: 2013
# Price: 28000.0
        let car3 = Car("Mercedes")
        car3.print_car_details()
# =>
# Make: Mercedes
# Model: Base
# Year: 0
# Price: 0.0
    