class Admin::BooksController < Admin::BaseController
    def index
      @categories = Category.asc_name
      @q = Book.asc_title.ransack(params[:q])
      @pagy, @books = pagy(@q.result, items: 8)
    end

    def show
      @book = Book.find_by id: params[:id]
    end

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
          format.html { redirect_to admin_book_path(@book), notice: "book was successfully created." }
          format.json { render :show, status: :created, location: @book }
        else
          format.js
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy

      @book = Book.find_by id: params[:id]
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
  end
