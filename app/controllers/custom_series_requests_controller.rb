class CustomSeriesRequestsController < ApplicationController
  def new
    @custom_series = current_user.custom_series.find(params[:series_id])
  end

  def create
    CustomSeriesRequest.where(custom_series_id: params[:custom_series_id], sender_id: current_user.id).delete_all
    @request = CustomSeriesRequest.new(custom_series_request_params)    
    @request.sender = current_user

    if @request.save
      Invitation.send_custom_series_request(@request).deliver
      flash[:notice] = "Request sent!"
      redirect_to :back
    else
      flash[:error] = "Request not sent! Please check the email address and try again"
      redirect_to :back
    end
  end

  # def send_request
  #   @request = CustomSeriesRequest.new(custom_series_request_params)
  #   @request.sender = current_user
    
  #   @custom_series = current_user.custom_series.find(params[:custom_series_request][:custom_series_id])    
  #   if @request.save
  #     Invitation.send_custom_series_request(@request).deliver
  #     flash[:notice] = "Request sent!"
  #     redirect_to :back
  #   else
  #     flash[:error] = "Request not sent! Please check the email address and try again"
  #     redirect_to :back
  #   end
  # end

  def destroy
    request = CustomSeriesRequest.find(params[:id])
    request.destroy if can? :destroy, request
    redirect_to custom_series_index_path
  end

protected 
  def custom_series_request_params
    params.permit(:custom_series_id)
  end
end
