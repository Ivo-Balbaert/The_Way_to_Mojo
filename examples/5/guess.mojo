
fn main():
    print(guessLuckyNumber(37)) # => True

fn guessLuckyNumber(guess: Int) -> Bool:    # 1
    let luckyNumber: Int = 37
    var result: StringLiteral = ""      # 2
    if guess == luckyNumber:            # 3
        result = "You guessed right!"   # => You guessed right!
        print(result)
        return True
    else:                               # 4
        result = "You guessed wrong!"
        print(result)
        return False
