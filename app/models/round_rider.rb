class RoundRider < ActiveRecord::Base
  default_scope { order("finished_position") } 
  belongs_to :round
  belongs_to :rider

  validates_presence_of :round
  validates_presence_of :rider
  validates_uniqueness_of :round_id, scope: :rider_id

  def finished_description
    (finished_position && round.finished?) ? "#{rider.to_s}" : rider.to_s
  end
end
