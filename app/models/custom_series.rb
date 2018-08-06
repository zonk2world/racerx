class CustomSeries < ActiveRecord::Base
  belongs_to :series
  belongs_to :owner, class_name: 'User', foreign_key: :user_id

  has_many :custom_series_licenses, dependent: :destroy
  has_many :users, through: :custom_series_licenses

  has_many :custom_series_invitations, dependent: :destroy
  has_many :custom_series_requests, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :series

  scope :public_list, -> { where(is_public: true) }
  scope :private_list, -> { where.not('is_public is true') }
  
  def includes_user?(user)
    users.include?(user)
  end

end
