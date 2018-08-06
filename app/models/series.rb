class Series < ActiveRecord::Base
  has_many :race_classes
  has_many :rounds, through: :race_classes
  has_many :series_licenses
  has_many :users, through: :series_licenses
  has_many :custom_series

  validates :cost, numericality: true, presence: true

  scope :completed_list, -> { where(complete: true) }
  scope :available_list, -> { where(complete: false) }

  def ranked_licenses
    series_licenses.where('rank > 0')
  end

  def race_class_by_name(name)
    race_classes.find_by(name: name)
  end

  def to_s
    name
  end
  
  def to_param
    "#{id}-#{to_s.parameterize}"
  end


end
