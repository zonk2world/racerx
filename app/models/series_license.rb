class SeriesLicense < ActiveRecord::Base
  belongs_to :user
  belongs_to :series

  validates_presence_of :user
  validates_presence_of :series
  validates_uniqueness_of :user_id, scope: :series_id

  def save_with_payment
    if valid?
      user.remove_credits(series.cost)
      self.save
    end
  end
end
