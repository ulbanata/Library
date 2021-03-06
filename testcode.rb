
lib = Library.new
lib.register_new_book("Eloquent JavaScript", "Marijn Haverbeke")
lib.register_new_book("Essential JavaScript Design Patterns", "Addy Osmani")
lib.register_new_book("JavaScript: The Good Parts", "Douglas Crockford")


kors = Borrower.new("Michael Kors")
book = lib.check_out_book(lib.available_books.first.id, kors)
book = lib.check_out_book(lib.available_books[1].id, kors)

lib.book_due_dates
lib.overdue_books
