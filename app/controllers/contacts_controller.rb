class ContactsController < ApplicationController
  before_action :check_user
  before_action :set_user
  before_action :set_contact, only: [:show, :update, :destroy]
  # GET /users/:user_id/contacts
  def index
    @contacts = @user.contacts.where(is_active: true)

    render json: @contacts
  end

  # GET /users/:user_id/contacts/:id
  def show
    render json: @contact
  end

  # POST /users/:user_id/contacts
  def create
    @contact = @user.contacts.build(contact_params)

    if @contact.save
      render json: @contact, status: :created, location: user_contact_url(@user, @contact)
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:user_id/contacts/:id
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:user_id/contacts/:id
  def destroy
    @contact.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(@jwt_payload["id"])
  end

  def set_contact
    @contact = @user.contacts.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def contact_params
    params.require(:contact).permit(:full_name, :is_active)
  end

  def check_user
    @jwt_payload = getPayload()

    if (@jwt_payload["id"].to_i != params[:user_id].to_i)
      render json: {
        status: { code: 400, message: "params user not matching with payload cookie Found" },
      }, status: :unauthorized
      return
    end
  end

  def getPayload
    token = cookies["auth"]

    if !token
      render json: {
        status: { code: 400, message: "cookies Not Found" },
      }, status: :unauthorized
      return
    end
    payload = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base)).first

    if !payload
      render json: {
        status: { code: 400, message: "payload Not decodeable" },
      }, status: :unauthorized
      return
    end

    return payload
  end
end
