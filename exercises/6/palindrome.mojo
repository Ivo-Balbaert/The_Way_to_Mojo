fn is_palindrome(str: String) -> Bool:
    var half_len : Float64 = len(str) / 2
    for i in range(0, half_len.to_int()):
        if str[i] != str[len(str) - 1 - i]:
            return False
    return True


fn main():
    print(is_palindrome("ava")) # => True
    print(is_palindrome("otto")) # => True 
    print(is_palindrome("nothing")) # => False
