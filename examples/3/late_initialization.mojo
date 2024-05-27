fn main():
    var discount_rate: Float64  # 1 - no initialization yet! 
    # print(discount_rate)      # 2 - error: use of uninitialized value 'discount_rate'
    var book_id: Int = 123      # 3 - typing and initialization
    # 4 - Late initialization and pattern matching with if/else
    if book_id == 123:
        discount_rate = 0.2  # 20% discount for mystery books
    else:
        discount_rate = 0.05  # 5% discount for other book categories
    print("Discount rate for Book with ID ", book_id, "is:", discount_rate)
# => Discount rate for Book with ID  123 is: 0.20000000000000001
