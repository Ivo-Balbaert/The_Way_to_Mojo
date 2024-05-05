fn sum(*values: Int) -> Int:   # 1
  var sum: Int = 0
  for value in values:
    sum = sum + value
  return sum

fn main():
    print(sum(1,2,3))  # => 6
    print(sum(1,2,3,4,5,6,7))  # => 28
    print(sum(1))  # => 1
    print(sum())   # => 0