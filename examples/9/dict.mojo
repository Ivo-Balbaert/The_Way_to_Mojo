from collections import Dict

fn main() raises:
    var capitals = Dict[String, String]()
    capitals["California"] = "Sacramento"
    capitals["Hawaii"] = "Honolulu"
    capitals["Oregon"] = "Salem"

    print("capital, ", "state / :")
    for state in capitals:                  #0A
        print(capitals[state[]] + ", " + state[], end=" / ")
    # capital,  state / :
    # Sacramento, California / Honolulu, Hawaii / Salem, Oregon / 

    print()
    for item in capitals.items():           #0B
        print(item[].value + ", " + item[].key, end=" / ")
    # Sacramento, California / Honolulu, Hawaii / Salem, Oregon / 
    print()

    var d = Dict[String, Float64]()
    d["plasticity"] = 3.1                   # 1
    d["elasticity"] = 1.3
    d["electricity"] = 9.7
    for item in d.items():                  # 1B
        print(item[].key, item[].value)     # 2
    # =>
    # plasticity 3.1000000000000001
    # elasticity 1.3
    # electricity 9.6999999999999993

    var d1 = Dict[String, Int]()
    d1["a"] = 1
    d1["b"] = 2
    print(len(d1))      # => 2
    print(d1["a"])      # => 1
    print(d1.pop("b"))  # => 2
    print(len(d1))      # => 1