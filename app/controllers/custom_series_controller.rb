class CustomSeriesController < ApplicationController
  respond_to :json

  def index
    @private_custom_series = current_user.custom_series.private_list
    @public_custom_series = current_user.custom_series.public_list
  end

  def show
    @custom_series = CustomSeries.find(params[:id])    
    @invite = CustomSeriesInvitation.for_token_and_email(params[:token], current_user.email)    
  rescue CustomSeriesInvitation::EmailMismatchError
    @email_mismatch_error = true
  rescue ActiveRecord::RecordNotFound
    @token_error = true
  end

  def show_request
    @custom_series = CustomSeries.find(params[:custom_series_id])
    @request = CustomSeriesRequest.find_by_token(params[:request_token])
  rescue CustomSeriesInvitation::EmailMismatchError
    @email_mismatch_error = true
  rescue ActiveRecord::RecordNotFound
    @token_error = true
  end

  def new_private
    @new_private_custom_series = CustomSeries.new
    @new_private_custom_series.is_public = false
  end

  def new_public
    @new_public_custom_series = CustomSeries.new
    @new_public_custom_series.is_public = true
  end

  def create
    custom_series = current_user.owned_series.build(custom_series_params)
    if custom_series.save
      custom_series.custom_series_licenses.create(user: current_user)
      flash[:notice] = "Private Series successfully created."
      redirect_to :back
    else 
      flash[:error] = "Private Series failed to be created because #{custom_series.errors.messages}"
      redirect_to :back 
    end
  end
  
  def edit
    @custom_series = current_user.custom_series.find(params[:id])
  end

  def update
    @custom_series = CustomSeries.find(params[:id])
    @custom_series.update_attributes(custom_series_params)
    flash[:notice] = 'The series has been updated successfully.'
    redirect_to action: 'index'
  end

  def destroy
    @custom_series = current_user.custom_series.find(params[:id])
    @custom_series.destroy
    flash[:notice] = 'The series has been deleted successfully.'
    redirect_to action: 'index'
  end

  def search    
    @custom_series_list = CustomSeries.where.not(user_id: current_user.id).where("name like ?", "%#{params[:keyword]}%").limit(40)
  end
  
private 
  
  def custom_series_params
    params.require(:custom_series).permit(:name, :series_id, :is_public)
  end
end
