class UsersController < ApplicationController
  def index
    @users = User.all.where(is_active: true)
    render json: @users
  end

  def show
    @user = User.includes(contacts: :contact_infos).where(is_active: true).find(params[:id])
    render json: @user.as_json(include: { contacts: {
                                 include: :contact_infos,
                               } })
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.where(id: params[:id]).first

    if @user.update(user_params)
      # head(:ok)
      render json: @user
    else
      head(:unprocessable_entity)
    end
  end

  def destroy
    @user = User.where(id: params[:id]).first
    puts "@user.inspect111111111111111111111111111111111111111111111111111111111111"
    puts @user.inspect
    if @user.destroy
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :full_name, :is_admin, :is_active)
  end
end
