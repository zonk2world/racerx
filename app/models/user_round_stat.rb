class UserRoundStat < ActiveRecord::Base
  belongs_to :user
  belongs_to :round
  belongs_to :race_class
  belongs_to :series

  validates_presence_of :user
  validates_presence_of :round

  before_save :set_total

  def self.ransackable_attributes auth_object = nil
    super + ['rank','average']
  end

  private
  def set_total
    self.total = rider_score + heat_winner_score + pole_position_score + hole_shot_score
  end
end
