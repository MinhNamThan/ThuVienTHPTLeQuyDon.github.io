class StaticPagesController < ApplicationController
  def home;
    @categories = Category.all.limit(4)
    @subjects = Subject.asc_name
    @books = Book.order(updated_at: :desc).limit(8)
  end

  def about; end

  def login; end
end
