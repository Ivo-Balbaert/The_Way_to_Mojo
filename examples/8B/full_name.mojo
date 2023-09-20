@value
struct FullName:
    var first_name: String
    var last_name: String

    fn print(self):
        print(self.first_name, self.last_name)