class Rider < ActiveRecord::Base
  default_scope { order('race_number') } 
  has_many :round_riders, dependent: :destroy
  has_many :rounds, through: :round_riders
  has_many :points, as: :pointable, dependent: :destroy
  has_many :round_bonus_winners #round bonus wins
  has_many :rider_positions

  validates :name, presence: true, uniqueness: true
  validates_presence_of :race_number

  belongs_to :team

  def points_total
    rider_positions.to_a.sum(&:score)
  end

  def user_rider_points_total(user)
    rider_positions.where(user_id: user).to_a.sum(&:score)
  end 

  def to_s
    [race_number, name].reject(&:blank?).join(" ")
  end
end
