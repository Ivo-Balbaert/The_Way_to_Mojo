@value
struct Employee:
    var name: String
    var age: Int
    var department: String
    var salary: Float64
    
    fn print_details(employee: Employee):
        print("Name:", employee.name)
        print("Age:", employee.age)
        print("Department:", employee.department)
        print("Salary:", employee.salary)

    fn print_details(self: Employee, include_salary: Bool):
        print("Employee Name: ", self.name)
        print("Employee Age: ", self.age)
        print("Department: ", self.department)
        if include_salary:
            print("Salary: ", self.salary)

fn print_details(name: String, age: Int):
    print("Name: ", name)
    print("Age: ", age)

fn print_details(name: String, age: Int, department: String):
    print("Name: ", name)
    print("Age: ", age)
    print("Department: ", department)

fn main():
    # Create employee instances
    var employee1 = Employee("Alice Thompson", 30, "Engineering", 5000.0)
    let employee2 = Employee("Robert Davis", 35, "Sales", 4500.0)
    employee1.age = 33

    # Print employee details
    # Method overloading:
    employee1.print_details()
    employee2.print_details()
# =>
# Name: Alice Thompson
# Age: 33
# Department: Engineering
# Salary: 5000.0
# Name: Robert Davis
# Age: 35
# Department: Sales
# Salary: 4500.0
    employee2.print_details(False)
# =>
# Employee Name:  Robert Davis
# Employee Age:  35
# Department:  Sales
    print()
# Function Overloading
    print_details("Alice Thompson", 30)
    print_details("Robert Davis", 35, "Sales")
# =>
# Name:  Alice Thompson
# Age:  33
# Name:  Robert Davis
# Age:  35
# Department:  Sales