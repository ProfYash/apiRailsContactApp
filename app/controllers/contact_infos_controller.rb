class ContactInfosController < ApplicationController
  before_action :set_user
  before_action :set_contact
  before_action :set_contact_info, only: [:show, :update, :destroy]

  def index
    @contact_infos = @contact.contact_infos.where(is_active: true)
    render json: @contact_infos
  end

  def show
    render json: @contact_info
  end

  def new
  end

  def create
    puts "11111111111create111111111111111111111111111"
    puts @contact.inspect
    @contact_info = @contact.contact_infos.build(contact_info_params)

    if @contact_info.save
      render json: @contact_info, status: :created
    else
      render json: @contact_info.errors, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @contact_info.update(contact_info_params)
      render json: @contact_info, status: :accepted
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @contact_info.destroy
    render json: @contact_info, status: :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.where(is_active: true).find(params[:user_id])
  end

  def set_contact
    @contact = @user.contacts.where(is_active: true).find(params[:contact_id])
  end

  def set_contact_info
    puts "111111111111111111111111111set_contact_info!!!!!!!!!!!!!!!!!!!!!"
    @contact_info = @contact.contact_infos.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def contact_info_params
    params.require(:contact_info).permit(:category, :number, :is_active)
  end
end
