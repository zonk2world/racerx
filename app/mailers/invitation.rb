class Invitation < ActionMailer::Base
  default from: "no-reply@motodynasty.com"

  def send_private_series_invite(invite)
    @invite = invite
    mail(:to => invite.recipient_email, from: invite.sender.email, 
      subject: "Join the MotoDynasty private series #{invite.custom_series.name}")
  end
  def send_public_series_invite(invite)
    @invite = invite
    mail(:to => invite.recipient_email, from: invite.sender.email, 
      subject: "Join the MotoDynasty public series #{invite.custom_series.name}")
  end

  def send_custom_series_request(request)
    @request = request
    mail(:to => request.custom_series.owner.email, from: request.sender.email, 
      subject: "Request for Series #{request.custom_series.name} from #{request.sender.email}")
  end

  # def send_private_series_invite(invite)
  #   @invite = invite
  #   mail(:to => invite.recipient_email, from: invite.sender.email, subject: "Join the MotoDynasty private series #{invite.custom_series.name}")
  # end
end
