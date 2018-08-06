class UserMessagesController < ApplicationController
  skip_authorize_resource
    
  def new
    @user_message = UserMessage.new
  end

  def create
    @user_message = UserMessage.new(user_message_params)
    if @user_message.valid?
      UserMessages.user_message(@user_message).deliver
      flash[:notice] = "Message sent! Thank you for contacting us."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

protected
  
  def user_message_params
    params.require(:user_message).permit(:name, :email, :subject, :content)
  end

end