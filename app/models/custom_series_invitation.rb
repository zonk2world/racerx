class CustomSeriesInvitation < ActiveRecord::Base

  class EmailMismatchError < StandardError
  end

  belongs_to :sender, class_name: 'User'
  belongs_to :custom_series

  validates_presence_of :recipient_email, :sender, :custom_series
  validates_format_of :recipient_email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  before_create :generate_token
  
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

  def self.for_token_and_email(token, recipient_email)
    potential_invite = find_by_token! token
    if recipient_email.downcase == potential_invite.recipient_email.downcase
      potential_invite
    else
      raise EmailMismatchError
    end
  end
end
