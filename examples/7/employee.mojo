@value
struct Employee:
    var name: String
    var age: Int
    var department: String
    var salary: Float64

    fn print_details(self):
        print("Name:", self.name)
        print("Age:", self.age)
        print("Department:", self.department)

    fn print_details(self, include_salary: Bool):
        print_details(self)
        if include_salary:
            print("Salary: ", self.salary)


fn print_details(employee: Employee):
    print("Name: ", employee.name)
    print("Age: ", employee.age)
    print("Department:", employee.department)


fn print_details(employee: Employee, include_salary: Bool):
    print_details(employee)
    if include_salary:
        print("Salary: ", employee.salary)


fn main():
    # Create employee instances
    var employee1 = Employee("Alice Thompson", 30, "Engineering", 5000.0)
    var employee2 = Employee("Robert Davis", 35, "Sales", 4500.0)
    employee1.age = 33

    # Print employee details
    # Method overloading:
    employee1.print_details()
    print()
    employee2.print_details()
    # =>
    # Name: Alice Thompson
    # Age: 33
    # Department: Engineering

    # Name: Robert Davis
    # Age: 35
    # Department: Sales
    print()
    employee2.print_details(True)
    # =>
# Name:  Robert Davis
# Age:  35
# Department: Sales
# Salary:  4500.0
    print()
    # Function Overloading
    print_details(employee1, True)
    print()
    print_details(employee2)
# Name:  Alice Thompson
# Age:  33
# Department: Engineering
# Salary:  5000.0

# Name:  Robert Davis
# Age:  35
# Department: Sales