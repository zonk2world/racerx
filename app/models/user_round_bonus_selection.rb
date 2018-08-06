class UserRoundBonusSelection < ActiveRecord::Base
  belongs_to :user
  belongs_to :round
  belongs_to :rider
  belongs_to :bonus_type

  validates_presence_of :user
  validates_presence_of :round
  validates_presence_of :rider
  validates_presence_of :bonus_type
end
