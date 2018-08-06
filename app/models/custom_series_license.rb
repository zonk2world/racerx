class CustomSeriesLicense < ActiveRecord::Base
  belongs_to :user
  belongs_to :custom_series

  validates_presence_of :user
  validates_presence_of :custom_series
  validates_uniqueness_of :user_id, scope: :custom_series_id
end
