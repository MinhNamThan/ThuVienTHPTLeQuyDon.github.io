class Admin::BooksController < Admin::BaseController
    before_action :find_book, except: %i(index new create)
    def index
      @categories = Category.asc_name
      @q = Book.asc_title.ransack(params[:q])
      @pagy, @books = pagy(@q.result, items: 8)
    end

    def show; end

    def new
      @subjects = Subject.asc_name
      @categories = Category.asc_name
      @book = Book.new
    end


    def create
      @book = Book.new(book_params)
      respond_to do |format|
        if @book.save
          CreateImagesOfPdfPagesJob.set(wait: 2.seconds).perform_later(@book.id)
          format.js
          format.html { redirect_to book_path(@book), notice: "book was successfully created." }
          format.json { render :show, status: :created, location: @book }
        else
          format.js
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end


    def edit
      @subjects = Subject.asc_name
      @categories = Category.asc_name
    end

    def update
      if @book.update book_params
        flash[:success] = "Book updated"
        redirect_to admin_books_path
      else
        flash[:danger] = "Not updated book"
        render :edit
      end
    end

    def destroy
      @book.destroy
      respond_to do |format|
        format.html { redirect_to admin_books_url, notice: "book was successfully destroyed." }
        format.json { head :no_content }
    end
    end

      private

      def set_book
        @book = book.find(params[:id])
      end

    def book_params
      params.require(:book).permit(:id, :title, :author,
                                    :subject_id, :grade, :category_id, :describe, :publish_on, :doc_file)
    end

    def find_book
      @book = Book.find_by id: params[:id]
      return if @book

      flash[:danger] = "Sách không tồn tại"
      redirect_to admin_books_url
    end
  end
