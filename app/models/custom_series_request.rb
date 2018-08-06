class CustomSeriesRequest < ActiveRecord::Base

  belongs_to :sender, class_name: 'User'
  belongs_to :custom_series

  before_create :generate_token
  
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

end
