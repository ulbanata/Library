
class Book
  attr_reader :author
  attr_reader :title
  attr_reader :id
  attr_reader :status

  def initialize(title="The Stranger", author="Albert Camus")
    @author = author
    @title = title
    @id = nil
    @status = 'available'
  end

  def check_out
    if @status == 'available'
      @status = 'checked_out'
      return true
    else
      return false
    end
  end

  def check_in
    @status = 'available'
  end


end

class Borrower
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

class Library
  attr_reader :books
  def initialize
    @books = []
    @count = 0
  end

  def register_new_book(name, author)
    @books << Book.new(name, author)
  end

  # def books
  #   def count
  #     @count += 1
  #   end
  # end

  def add_book(title, author)
  end

  def check_out_book(book_id, borrower)
  end

  def check_in_book(book)
  end

  def available_books
  end

  def borrowed_books
  end
end
