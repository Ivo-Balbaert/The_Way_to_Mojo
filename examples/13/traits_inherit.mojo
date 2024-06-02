trait Flyable:
    fn fly(self):
        ...


trait Walkable:
    fn walk(self):
        ...


trait WalkableFlyable(Flyable, Walkable):
    ...


struct Bird(WalkableFlyable):
    fn __init__(inout self):
        ...

    fn fly(self):
        print("Fly to the sky")

    fn walk(self):
        print("Walk on the ground")


fn main():
    Bird().fly()
    Bird().walk()
