class BooksController < ApplicationController
    before_action :logged_in_user, only: [:show]
    BOOKS_PER_PAGE = 6

    def index
        if (params[:sorts]) then
            @sorts = params[:sorts]
            @sorts[":"] = " "
        else
            @sorts = "title"
        end
        @subject_list = Subject.all
        @category_list = Category.all
        @subject = params[:subject] ? params[:subject] : []
        @category = params[:category] ? params[:category] : []
        @page = [params.fetch(:page, 1).to_i, 1].max
        @totalPage = (Book.all.count * 1.0 / BOOKS_PER_PAGE).ceil
        @books = Book.all
        if (@subject.length > 0)
            @books = @books.where("subject_id in (?)", @subject)
        end
        if (@category.length > 0)
            @books = @books.where("category_id in (?)", @category)
        end
        @books = @books.order(@sorts).offset((@page - 1) * BOOKS_PER_PAGE).limit(BOOKS_PER_PAGE)
    end

    def new
    end

    def search
        @query = params[:q] ? params[:q] : ""
        @totalResult = Book.where("title LIKE ?", "%" + @query + "%").count
        @totalPage = (@totalResult* 1.0 / BOOKS_PER_PAGE).ceil
        @page = [params.fetch(:page, 1).to_i, 1].max
        @books = Book.where("title LIKE ?", "%" + @query + "%").order("title").offset((@page - 1) * BOOKS_PER_PAGE).limit(BOOKS_PER_PAGE)
    end


    def show
        @book = Book.find(params[:id])
    end

    def read
        @book = Book.find(params[:id])
        num_watch = @book.num_watch + 1
        @book.update_attribute :num_watch, num_watch
    end
  end
