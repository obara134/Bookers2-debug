class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :book_edit_check,only: [:edit]
  def index
    @user = User.find(current_user[:id])
    logger.debug(@user.to_yaml)
    @new_book = Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @user = User.find(current_user[:id])
      @books = Book.all
      @new_book = Book.new
      render :index
    end
  end

  def show

    @book = Book.find(params[:id])
    @user = User.find(@book.user_id)
    @new_book = Book.new

  end

  def edit
    @new_book = Book.find(params[:id])
    @user = User.find(@book.user_id)

  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book was successfully updated."
      redirect_to book_path(@book.id)
    else

      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

   private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def book_edit_check
    @book = Book.find(params[:id])
    if @book.user != current_user
      redirect_to books_path
    end
  end
end