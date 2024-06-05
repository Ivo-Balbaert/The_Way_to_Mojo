struct MyStruct:
    var fields: Dict[String, String]

    fn __init__(inout self, fields: Dict[String, String]):
        self.fields = fields

    fn __getattr__(self, attr: String) raises -> String:
        return self.fields[attr]

    fn __setattr__(inout self, attr: String, value: String) raises:
        self.fields[attr] = value


fn main() raises:
    var d: Dict[String, String] = Dict[String, String]()
    d["name"] = "IK"
    var st = MyStruct(d)
    print(st.name)  # => IK #  __getattr__ is called here
    st.name = "PK"  # __setattr__ is called here
    print(st.name)  # => PK
