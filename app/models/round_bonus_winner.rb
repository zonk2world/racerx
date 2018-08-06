class RoundBonusWinner < ActiveRecord::Base
  belongs_to :rider
  belongs_to :round
  belongs_to :bonus_type

  validates_presence_of :rider
  validates_presence_of :round
  validates_presence_of :bonus_type
  
end
