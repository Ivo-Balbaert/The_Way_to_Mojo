struct Car:
    var speed: Int
    var model: String

    fn __init__(inout self, speed: Int):
        """Car with only speed."""
        self.speed = speed
        self.model = 'Base'

    fn __init__(inout self, speed: Int, model: String):
        """Car with Speed and model."""
        self.speed = speed
        self.model = model

fn main():
    let my_car = Car(120)
    print(my_car.model) # => Base