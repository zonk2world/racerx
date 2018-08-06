class BonusType < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  def self.ordered
    %w{PolePosition HeatWinner HoleShot}.map{|name| BonusType.find_by(name: name) }
  end

  def to_s
    name.titleize
  end
end
