struct Resource:
    var name: String

    fn __init__(inout self, name: String):
        self.name = name

    fn open(self):
        print("Opened")

    fn close(self):
        print("Close")

    fn __copyinit__(inout self, other: Resource):
        self.name = other.name


struct MyResourceManager:
    var resource: Resource

    fn __init__(inout self):
        self.resource = Resource("a_resource")

    fn __enter__(self) -> Resource:
        print("Entered context")
        self.resource.open()
        return self.resource

    fn __exit__(self):
        self.resource.close()
        print("Exited context")

    fn __exit__(self, err: Error) -> Bool:
        self.resource.close()
        print("Exited context")
        return False


fn main() raises:
    with MyResourceManager() as res:
        print("Inside context, resource is:", res.name)
        # raise Error("An error while processing")


# => when # raise Error:
# Entered context
# Opened
# Inside context, resource is: a_resource
# Close
# Exited context

# => when raise Error:
# Entered context
# Opened
# Inside context, resource is: a_resource
# Close
# Exited context
# Unhandled exception caught during execution: An error while processing
# mojo: error: execution exited with a non-zero result: 1
