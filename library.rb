
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
    @borrower = []
  end

  def check_out(borrower)
    puts @status
    if @status == 'available' && borrower.checked_out < 2
      @status = 'checked_out'
      @borrower << borrower
      @borrower.first.checked_out += 1
      return true
    else
      return false
    end
  end

  def check_in
    @status = 'available'
    @borrower.first.checked_out -= 1
    @borrower = []
  end


end

class Borrower
  attr_reader :name
  attr_accessor :checked_out
  def initialize(name)
    @checked_out = 0
    @name = name
  end
end

class Library
  attr_reader :books
  attr_reader :count
  attr_accessor :available_books
  attr_accessor :borrowed_books
  def initialize
    @books = []
    @count = 0
    @borrowed_books =[]
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
      puts @books
      if x.id == book_id && x.check_out(borrower)
        return x
      end
    end
    return nil
  end

  def get_borrower(book_id)
    @books.each do |x|
      if x.id == book_id
        return x.borrower.first.name
      end
    end
  end

  def check_in_book(book)
    book.check_in
  end

  def available_books
    @books.select { |x| x.status == 'available' }
  end

  def borrowed_books
    @books.select { |x| x.status == 'checked_out' }
  end
end
