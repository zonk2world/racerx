class RiderPosition < ActiveRecord::Base
  default_scope { order('position') } 
  belongs_to :rider
  belongs_to :round
  belongs_to :user

  validates_presence_of :round
  validates_presence_of :user
  validates_uniqueness_of :rider, scope: [:round_id, :user_id]

  delegate :race_class, to: :round
end
