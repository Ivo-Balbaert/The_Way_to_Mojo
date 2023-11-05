from random import random_float64, seed

alias flip_a_coin = random_float64
alias tail = 0.5


def say_three():
    raise Error("⚠️ no time to say three")


fn count_to_5() raises:
    print("count_to_5: one")
    print("count_to_5: two")
    try:
        _ = say_three()
    except e:
        print("\t count_to_5: error", e)

        if flip_a_coin() > tail:
            raise Error("⚠️ we stopped at three")
        else:
            print("count_to_5: three ⛑️")

    print("count_to_5: four")
    print("count_to_5: five")


fn main() raises:
    seed()

    try:
        count_to_5()
    except e:
        print("error inside main(): ", e)
        # main: error e
        if e.__repr__() == "⚠️ we stopped at three":
            print("main: three ⛑️")
            print("main: four ⛑️")
            print("main: five ⛑️")

    print("✅ main function: all good") 
# =>
# count_to_5: one
# count_to_5: two
# 	 count_to_5: error ⚠️ no time to say three
# count_to_5: three ⛑️
# count_to_5: four
# count_to_5: five
# ✅ main function: all good

# or:
# count_to_5: one
# count_to_5: two
# 	 count_to_5: error ⚠️ no time to say three
# error inside main():  ⚠️ we stopped at three
# main: three ⛑️
# main: four ⛑️
# main: five ⛑️
# ✅ main function: all good