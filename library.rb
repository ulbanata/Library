=begin
Below is the library project of Patrick Brennan.
This currently includes everything from 1-12 and 14.
On 14, asking about scheduling a future checkout, I really
didn't like the problem/question. If you automatically set it up
to check out a book once the current borrower checks it in,
the person checking it out won't actually have it. What I ended
up doing was creating a waiting list, called @waitlist, in the
Book object.  If you try to check out a book that is already
checked out, you are added to the waiting list and only you
can check out that book once it is returned. It seemed like a
more sensible solution to me.

Things I want to do, but too sick right now to get to:
Parts 13 and 15. Optional attributes should be nice
but can't find a good resource yet on how to do them. CSV will
be very helpful because everyone seems to have all of their
data on excel instead of in a database.

Add a new method that takes care of finding a book based off
its id. I have two different methods doing that already, can
refactor it down to one.

Figure out what to do with the Book.check_in method. There
should be an easy solution that lets me call a this on the
current object I'm in.

Change the arrays that hold one object (Like who checked
out a book) to variables that hold an object and take out
all the firsts I don't need.
=end

#Date required for part 14 TIME LIMITs
require 'date'

class Book
  #Usual attr_readers. Individual lines for easy reading
  attr_reader :author
  attr_reader :title
  attr_reader :id
  attr_reader :status
  attr_reader :borrower
  attr_reader :due_date

  #Counter for Book class initalizations for a book id
  @@count = 0

  def initialize(title, author)
    @author = author
    @title = title
    @status = 'available'
    @@count += 1
    @id = @@count
    @borrower = []
    @due_date = nil
    @waitlist = []
  end

  #Check out a book, takes a Borrower object
  def check_out(borrower_obj)
    overdue = check_overdue(borrower_obj)
    cur_date = Time.new
    #Only check out a book if it is available,
    #the borrower doesn't have 2 already checked out
    #and does not have any over due books, and
    #there is no one on the waitlist or the person trying
    #to check out the book is the next person on the waitlist
    if (@status == 'available' && borrower_obj.checked_out.length < 2 && !overdue && (@waitlist.length == 0 || @waitlist.first.name == borrower_obj.name))
      @status = 'checked_out'
      #Adds the borrower to the book borrower array
      #Might be able to go with = and remove all of the .firsts
      @borrower << borrower_obj
      #Sets the due date as time checked out + 7 days
      @due_date = Time.now + 604800
      #Removes the person from the waitlist if they're on it
      @waitlist.shift if @waitlist.length > 0
      #Tells the calling method the book was checked out
      return true
    else
      #Adds the borrower to the waitlist
      @waitlist << borrower_obj
      #Tells the calling method the book was not checked out
      return false
    end
  end

  def check_overdue(borrower_obj)
    #Runs through each book to see if the borrower has any overdue
    #If yes, returns true
    #Can probably take this down to one line if I do a .first
    #but if the number of books that can be checked out changes,
    #that would break this method.
    borrower_obj.checked_out.each do |book|
      return true if book.due_date <= Time.now
    end
    #If no books are overdue, returns false
    return false
  end

  #Checks in the book, making it available and setting borrower
  #array to empty.
  #Returns the borrower array before emptying it to clear
  #the book from borrower object. Not very elegant.
  #Is there a this for the book object? so I could call a
  #borrower.checked_out.delete(this)?
  def check_in
    @status = 'available'
    return @borrower
    @borrower = []
  end


end

#Borrower class, holds the name and the books that are checked
#out
class Borrower
  attr_reader :name
  attr_accessor :checked_out
  def initialize(name)
    @checked_out = []
    @name = name
  end
end

#Library class, holds an array of book objects
class Library
  attr_reader :books
  attr_reader :count
  attr_accessor :available_books
  attr_accessor :borrowed_books
  def initialize
    @books = []
    @borrowed_books =[]
  end

  #Creates a new book object and adds it to the @books array
  def register_new_book(name, author)
    @books << Book.new(name, author)
  end

  #Checks out a book by the book id
  def check_out_book(book_id, borrower)
    #Runs through each book in the library
    @books.each do |book|
      #If the book's id matches the id of the checkout id,
      #tries to check the book out
      if book.id == book_id && book.check_out(borrower)
        borrower.checked_out << book
        return book
      end
    end
    #If no match is found, returns nil
    return nil
  end

  #Figures out who is borrowing a book by a specific book id
  def get_borrower(book_id)
    #Runs through all books in the library and finds the one
    #that matches the id, then looks at the borrower
    #Currently no error protection if the book isn't borrowed
    @books.each do |book|
      return book.borrower.first.name if book.id == book_id
    end
  end

  #Checks in a book
  #This one is not by ID, it's by the book object itself
  def check_in_book(book)
    borrower = book.check_in
    #Removes the book from the borrower's checked out array
    borrower.first.checked_out.delete(book)
  end

  #Returns an array of book objects of available books
  def available_books
    @books.select { |book| book.status == 'available' }
  end

  #Returns an array of book objects of unavailable books
  def borrowed_books
    @books.select { |book| book.status == 'checked_out' }
  end

  #Prints a list of checked out books titles, due dates and
  #who borrowed it
  def book_due_dates
    borrowed_books.each { |book| puts "#{book.title} checked out by #{book.borrower.first.name}. Due date: #{book.due_date.strftime("%B %d, %Y")}."}
  end

  #Prints out a list of overdue books with the title and the
  #due date
  def overdue_books
    borrowed_books.each do |book|
        puts "#{book.title} was due on #{book.due_date.strftime("%B %d, %Y")}.}" if book.check_overdue(book.borrower.first)
    end
  end
end
