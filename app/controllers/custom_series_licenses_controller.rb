class CustomSeriesLicensesController < ApplicationController

  def create
    custom_series = CustomSeriesLicense.new(custom_series_license_params)
    custom_series.user = current_user
    if custom_series.save
      CustomSeriesInvitation.find(params[:custom_series_invitation_id]).destroy if params[:custom_series_invitation_id]      
      redirect_to custom_series_index_path
    else
      flash[:error] = "An error has occured. You were unable to join that private series. Please try again"
      puts "=== #{custom_series.errors.full_messages} ==="
      redirect_to root_path
    end
  end

  def join
    license = CustomSeriesLicense.new(custom_series_join_params)
    license.user = current_user
    if license.custom_series.is_public
      license.save
      redirect_to custom_series_index_path
    else
      flash[:error] = "An error has occured. You were unable to join that private series. Please try again"
      redirect_to root_path
    end
  end

  def accept_request
    license = CustomSeriesLicense.new(custom_series_license_request_params)
    request = CustomSeriesRequest.find(params[:custom_series_request_id])
    license.user = request.sender
    if license.save
      request.destroy
      redirect_to custom_series_index_path
    else
      flash[:error] = "An error has occured. You were unable to join that private series. Please try again"
      redirect_to root_path
    end
  end

  def leave_custom_series
    licenses = current_user.custom_series_licenses.where(custom_series_id: params[:custom_series_id])
    licenses.delete_all if licenses
    redirect_to custom_series_index_path    
  end

  def destroy
    license = CustomSeriesLicense.find params[:id]
    # license.destroy if can? :destroy, license.custom_series
    license.destroy if license.custom_series.owner == current_user || current_user == license.user
    redirect_to custom_series_index_path
  end

protected 
  def custom_series_license_params
    params.require(:custom_series_license).permit(:user_id, :custom_series_id)
  end
  def custom_series_join_params
    params.permit(:user_id, :custom_series_id)
  end
  def custom_series_license_request_params
    params.require(:custom_series_license).permit(:custom_series_id)
  end

end
