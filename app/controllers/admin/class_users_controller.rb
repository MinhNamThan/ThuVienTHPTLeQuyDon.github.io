class Admin::ClassUsersController < Admin::BaseController
    def index
      @query = params[:q] ? params[:q] : "";
      @result = ClassUser.where("name LIKE ? OR grade LIKE ?", "%" + @query + "%", "%" + @query + "%")
      @result = @result.asc_name
      @pagy, @class_users = pagy(@result, items: 8)
    end

    def new
      @class_user = ClassUser.new
    end

    def create
      @class_user = ClassUser.new class_user_params
    if @class_user.save
      flash[:success] = "welcome"
      redirect_to admin_class_users_path
    else
      flash[:danger] = "danger"
      render :new
    end
    end

    def edit
      @class_user = ClassUser.find(params[:id])
    end

    def update
      @class_user = ClassUser.find(params[:id])
      if @class_user.update class_user_params
        flash[:success] = "Profile updated"
        redirect_to admin_class_users_path
      else
        flash[:danger] = "danger"
        render :edit
      end
    end

    def destroy
      @class_user = ClassUser.find_by id: params[:id]
      if @class_user.destroy
        flash[:success] = "success"
      else
        flash[:danger] = "danger"
      end
      redirect_to admin_class_users_path
    end

    private

    def class_user_params
      params.require(:class_user).permit(:id, :name, :grade)
    end

  end
