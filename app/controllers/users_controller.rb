class UsersController < ApplicationController
  before_action :newSession, only: [:login]

  def login
    username = params[:username]
    password = params[:password]
    puts "username password1111111111111111111111"
    puts username, password
    if !(username && password)
      render json: {
        status: { code: 400, message: "Username or Password Empty", errors: resourse.errors.full_messages },
      }, status: :unprocessable_entity
      return
    end
    userToCheck = find_user_by_username(username)
    puts "userToCheck888888888888888888888888888888888888888881111111111111111111111"
    puts userToCheck.inspect
    if !userToCheck
      render json: {
               status: { code: 400, message: "User Not Found", errors: resourse.errors.full_messages },
             }, status: :unauthorized
      return
    end
    if userToCheck.password != password
      render json: {
               status: { code: 400, message: "Password Incorrect", errors: resourse.errors.full_messages },
             }, status: :unauthorized
      return
    end
    token = createToken(userToCheck)
    if !token
      render json: {
        status: { code: 400, message: "SignUp Invalid", errors: resourse.errors.full_messages },
      }, status: :unprocessable_entity
      return
    end
    createCookie(@cookie_name, token)
    render json: {
      status: { code: 200, message: "SignIn Done", data: userToCheck },
    }, status: :ok
    return
  end

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

  def find_user_by_username(username)
    user = User.all.where(username: username).first
    if user
      return user
    end
    return nil
  end

  def user_params
    params.require(:user).permit(:username, :password, :full_name, :is_admin, :is_active)
  end

  def createToken(user)
    jwt_token = JWT.encode(
      { id: user.id, is_active: user.is_active, is_admin: user.is_admin, full_name: user.full_name },
      Rails.application.credentials.fetch(:secret_key_base)
    )
    return jwt_token
  end

  def createCookie(name, value)
    puts "name1111111111111111111*******************"
    puts name
    cookies[name] = {
      :value => value,
      :expires => 1.year.from_now,
    }
  end

  def newSession
    @cookie_name = "auth"
    @cookie_session = " _contactApp_session"
    @cookie_session_id = " _session_id"
    puts "@newSession1222222222222222222222222222"
    puts @cookie_name
    cookies.delete @cookie_name
    cookies.delete @cookie_session_id
    cookies.delete @cookie_session
  end
end
