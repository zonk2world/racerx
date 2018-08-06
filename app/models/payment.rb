class Payment < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user

  after_create :add_credits_to_user

  def add_credits_to_user
    user.credits += self.amount
    user.save 
  end
end
