# start from cmd-line as: mojo -D testing param_env2.mojo
from sys.param_env import is_defined

alias testing = is_defined["testing"]()

# let's do colors for fun!
@always_inline
fn expect[message: StringLiteral ](cond: Bool):

    if cond: 
        # print in green
        print(chr(27), end="")
        print("[42m", end="")
    else: 
        # print in red
        print(chr(27), end="")
        print("[41m", end="")

    print(message)
    
    #reset to default colors
    print(chr(27), end="")
    print("[0m", end="")

fn main():
    @parameter
    if testing:
        print("this is a test build, don't use in production")
        expect["math check"](3 == (1 + 2))
        # prints "math check in green"
# => this is a test build, don't use in production
# math check
