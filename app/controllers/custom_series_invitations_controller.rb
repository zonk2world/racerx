class CustomSeriesInvitationsController < ApplicationController
  
  def new
    @custom_series = current_user.custom_series.find(params[:series_id])
  end

  def create
    @invitation = CustomSeriesInvitation.new(custom_series_invitations_params)
    @invitation.sender = current_user
    
    @custom_series = current_user.custom_series.find(params[:custom_series_invitation][:custom_series_id])    
    if @invitation.save
      Invitation.send_private_series_invite(@invitation).deliver
      flash[:notice] = "Invitation sent!"
      redirect_to :back
    else
      flash[:error] = "Invitation not sent! Please check the email address and try again"
      redirect_to :back
    end
  end

  def destroy
    invitation = CustomSeriesInvitation.find(params[:id])
    invitation.destroy if can? :destroy, invitation
    redirect_to custom_series_index_path
  end

protected 
  def custom_series_invitations_params
    params.require(:custom_series_invitation).permit(:recipient_email, :custom_series_id)
  end
end
