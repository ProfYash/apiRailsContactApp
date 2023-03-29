class ContactsController < ApplicationController
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
    @user = User.find(params[:user_id])
  end

  def set_contact
    @contact = @user.contacts.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def contact_params
    params.require(:contact).permit(:full_name, :is_active)
  end
end
