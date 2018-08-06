class UserMessages < ActionMailer::Base
  default from: "pitcrew@motodynasty.com"

  def user_message(user_message)
    @user_message = user_message
    mail(:to => "User Feedback <pitcrew@motodynasty.com>", from: "#{user_message.email}", subject: "#{user_message.subject}")
  end
end
