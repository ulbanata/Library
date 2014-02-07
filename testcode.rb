
lib = Library.new
lib.register_new_book("Eloquent JavaScript", "Marijn Haverbeke")
lib.register_new_book("Essential JavaScript Design Patterns", "Addy Osmani")
lib.register_new_book("JavaScript: The Good Parts", "Douglas Crockford")

# At first, no books are checked out
expect(lib.borrowed_books.count).to eq(0)

kors = Borrower.new("Michael Kors")
book = lib.check_out_book(lib.available_books.first.id, kors)

# But now there should be one checked out book
expect(lib.borrowed_books.count).to eq(1)
expect(lib.borrowed_books.first).to be_a(Book)
