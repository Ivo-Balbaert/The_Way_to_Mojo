def bookstore_management1(new_books, sold_books):
    # Declaring an immutable var iable 'total_books' with 'let'
    var total_books = new_books
    print("Total books:")
    print(total_books)
    # Uncommenting the next line would result in an error because 'total_books' is immutable
    # total_books = total_books - 40  # error: 'total_books' is immutable
    # Declaring a mutable variable 'current_books' with 'var'
    var  current_books = new_books
    print("Current books:")
    print(current_books)
    # Selling some books and reducing the current_books number
    current_books = current_books - sold_books
    print("Current books after reduction:")
    print(current_books)

    # Both 'let' and 'var ' support name shadowing and lexical scoping
    if total_books != current_books:
        var total_books = current_books
        print("Total books with lexical scoping, declared inside nested scope:")
        print(total_books)
    print("Total books in bookstore management function is still:")
    print(total_books)

def run_bookstore1():
    # Received 100 new books
    new_books = 100
    # Sold 20 books
    sold_books = 20
    bookstore_management1(new_books, sold_books)

def bookstore_management2(new_books: Int, sold_books: Int):
    # Declaring an immutable var iable 'total_books' with 'let'
    var total_books: Int = new_books
    print("Total books in store:", total_books)

    # Declaring a mutable var iable 'current_books' with 'var '
    var  current_books: Int = new_books
    print("Current books in store:", current_books)

    # Selling some books and reducing the current_books number
    current_books = current_books - sold_books
    print("Current books after selling:", current_books)

    # Both 'let' and 'var ' support name shadowing and lexical scoping
    if total_books != current_books:
        var total_books: Int = current_books
        print("Total books with lexical scoping, declared inside nested scope:", total_books)

    # Late initialization and pattern matching
    var discount_rate: Float64
    var book_category: String = "Mystery"
    if book_category == "Mystery":
        discount_rate = 0.2  # 20% discount for mystery books
    elif book_category == "Fantasy":
        discount_rate = 0.1  # 10% discount for fantasy books
    else:
        discount_rate = 0.05  # 5% discount for other book categories
    print("Discount rate for", book_category, "books is:", discount_rate)

def run_bookstore2():
    # Received 100 new books
    var new_books: Int = 100

    # Sold 20 books
    var sold_books: Int = 20

    bookstore_management2(new_books, sold_books)

fn main() raises:
    _ = run_bookstore1()
    _ = run_bookstore2()

# =>
# Total books:
# 100
# Current books:
# 100
# Current books after reduction:
# 80
# Total books with lexical scoping, declared inside nested scope:
# 80
# Total books in bookstore management function is still:
# 100
# Total books in store: 100
# Current books in store: 100
# Current books after selling: 80
# Total books with lexical scoping, declared inside nested scope: 80
# Discount rate for Mystery books is: 0.20000000000000001
