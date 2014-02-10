require 'date'

class Book
  attr_reader :author
  attr_reader :title
  attr_reader :id
  attr_reader :status
  attr_reader :borrower
  attr_reader :due_date

  @@count = 0

  def initialize(title, author)
    @author = author
    @title = title
    @status = 'available'
    @@count += 1
    @id = @@count
    @borrower = []
    @due_date = nil
  end

  def check_out(borrower_obj)
    overdue = check_overdue(borrower_obj)
    cur_date = Time.new
    if @status == 'available' && borrower_obj.checked_out.length < 2 && !overdue
      @status = 'checked_out'
      @borrower << borrower_obj
      @due_date = Time.now + 604800
      return true
    else
      return false
    end
  end

  def check_overdue(borrower_obj)
    cur_date = Time.now
    borrower_obj.checked_out.each do |book|
      return true if (book.due_date - cur_date) <= 0
    end
    return false
  end


  def check_in
    @status = 'available'
    return @borrower
    @borrower = []
  end


end

class Borrower
  attr_reader :name
  attr_accessor :checked_out
  def initialize(name)
    @checked_out = []
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
    @books.each do |book|
      if book.id == book_id && book.check_out(borrower)
        borrower.checked_out << book
        return book
      end
    end
    return nil
  end

  def get_borrower(book_id)
    @books.each do |book|
      if book.id == book_id
        return book.borrower.first.name
      end
    end
  end

  def check_in_book(book)
    borrower = book.check_in
    borrower.delete(book)
  end

  def available_books
    @books.select { |book| book.status == 'available' }
  end

  def borrowed_books
    @books.select { |book| book.status == 'checked_out' }
  end

  def book_due_dates
    book_list = borrowed_books
    book_list.each { |book| puts "#{book.title} checked out by #{book.borrower.first.name}. Due date: #{book.due_date.strftime("%B %d, %Y")}."}
  end
end
