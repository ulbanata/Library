
class Book
  attr_reader :author
  attr_reader :title
  attr_reader :id
  attr_reader :status
  attr_reader :borrower

  @@count = 0

  def initialize(title, author)
    @author = author
    @title = title
    @status = 'available'
    @@count += 1
    @id = @@count
    @borrower = ''
  end

  def check_out(borrower)
    if @status == 'available'
      @status = 'checked_out'
      @borrower = borrower.name
      return true
    else
      return false
    end
  end

  def check_in
    @borrower = ''
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
  attr_reader :count
  def initialize
    @books = []
    @count = 0
  end

  def register_new_book(name, author)
    @books << Book.new(name, author)
    @count += 1
  end

  # def add_book(title, author)
  #   @books << Book.new(name, author)
  #   @count += 1
  # end

  def check_out_book(book_id, borrower)
    @books.each do |x|
      if x.id == book_id && x.status == 'available'
        x.check_out(borrower)
        return x
      end
      return nil
    end
  end

  def get_borrower(book_id)
    @books.each do |x|
      if x.id == book_id
        return x.borrower
      end
    end
  end

  def check_in_book(book)

  end

  def available_books
  end

  def borrowed_books
  end
end
