class RaceClass < ActiveRecord::Base
  default_scope { order('id') } 
  belongs_to :series
  has_many :rounds
  has_many :licenses, as: :licensable

  def to_s
    name
  end

  def to_param
    "#{id}-#{to_s.parameterize}"
  end

  def registered?(user)
    licenses.where(user: user).any?
  end

  def registered_and_paid?(user)
    licenses.where(user: user, paid: true).any?
  end

  def unpaid_license?(user)
    licenses.where(user: user, paid: false).any?
  end

  def license_for(user)
    licenses.where(user: user).first || licenses.build(user: user)
  end

  def license_cost
    series.cost
  end

  def race_class
    self
  end

  def finished
    !rounds.unfinished.any?
  end

  def available_for_purchase?
    !finished && (series && series.cost != 0)
  end

  def create_paid_license(user, stripe_charge_id)
    if unpaid_license? user
      free_license = license_for user
      free_license.paid = true
      free_license.stripe_charge_id = stripe_charge_id
      free_license.save!
    else
      licenses.create! user: user, stripe_charge_id: stripe_charge_id, paid: true
    end

    UserRoundStat.where(user: user, race_class: self).each do |stats|
      stats.paid_race_class_license = true
      stats.save!
    end
  end
end
