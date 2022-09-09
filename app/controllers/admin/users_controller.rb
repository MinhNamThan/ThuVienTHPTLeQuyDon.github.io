class Admin::UsersController < Admin::BaseController
    def index
      if current_user.teacher?
        @q = User.student_with(current_user.class_user_id).asc_name.ransack(params[:q])
        @pagy, @users = pagy(@q.result, items: 10)
      else
        @q = User.asc_name.ransack(params[:q])
        @pagy, @users = pagy(@q.result, items: 10)
      end

    end

    def edit
      @class_users = ClassUser.asc_name
      @user = User.find_by id: params[:id]
    end

    def new
        @class_users = ClassUser.asc_name
        @user = User.new
    end

    def update
      params[:id] = params[:id].to_i
      @user = User.find_by id: params[:id]
      if @user.update user_params
        flash[:success] = "Successed"
        redirect_to admin_users_path
      else
        flash[:alert] = "Something was wrong"
        @class_users = ClassUser.asc_name
        render :edit
      end
    end

    def create
      @user = User.new(user_params)

      if @user.save
        flash[:success] = "Successed"
        redirect_to admin_users_path
      else
          flash[:danger] = "No No No No No No No"
          @class_users = ClassUser.asc_name
          render :new
      end
    end

    def destroy
      @user = User.find_by id: params[:id]
      if @user.destroy
        flash[:success] = "success"
      else
        flash[:danger] = "danger"
      end
      redirect_to admin_users_path
    end

    def user_params
      params.require(:user).permit(:id, :Tk, :password, :name, :birthday, :email, :role, :class_user_id)
    end
  end
