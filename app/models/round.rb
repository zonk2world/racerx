class Round < ActiveRecord::Base
  default_scope { order('end_time') } 
  scope :unfinished, -> { where(finished: false) }
  belongs_to :race_class

  has_many :round_riders, dependent: :destroy
  has_many :riders, through: :round_riders
  has_many :rider_positions, dependent: :destroy
  has_many :users, through: :rider_positions
  has_many :licenses, as: :licensable

  has_many :round_bonus_winners, dependent: :destroy

  validates_presence_of :start_time
  validates_presence_of :end_time
  validate :round_bonus_winners_present, if: :finished?
 
  def round_bonus_winners_present
    
  end

  def bonus_winners_set?
    bonus_winners_of_type("HeatWinner").present? &&
    bonus_winners_of_type("PolePosition").present? &&
    bonus_winners_of_type("HoleShot").present?
  end

  delegate :series, to: :race_class, allow_nil: true

  after_save :start_computing_score, if: :finished_changed?

  # FIXME: Refactor current_for into RaceClass#current_round
  def self.current_for(race_class)
    race_class.rounds.where(finished: false).first
  end

  def self.last_week_round(race_class)
    race_class.rounds.where(finished: true).last
  end
  

  # FIXME: Refactor finished_for into RaceClass#finished_rounds
  def self.finished_for(race_class)
    race_class.rounds.finished
  end

  def self.finished
    where finished: true
  end

  def round_riders_where_finished_is(bool)
    bool ? round_riders.where('finished_position is NOT NULL') : round_riders.where('finished_position is NULL')
  end

  def rider_selection_open?
    Time.now.between?(start_time, end_time)
  end

  def started? 
    Time.now.between?(race_start, race_end) if (race_start.present? && race_end.present?)
  end

  def bonus_winners_of_type(type)
    bonus_type = BonusType.find_by_name(type)
    round_bonus_winners.where(bonus_type_id: bonus_type.id)
  end

  def registered?(user)
    licenses.where(user: user).any? || race_class.registered?(user)
  end

  def registered_and_paid?(user)
    licenses.where(user: user, paid: true).any? || race_class.registered_and_paid?(user)
  end

  def unpaid_license?(user)
    (licenses.where(user: user, paid: false).any? && !race_class.registered_and_paid?(user)) ||
    (race_class.unpaid_license?(user) && !registered_and_paid?(user))
  end

  def license_for(user)
    licenses.where(user: user).first || race_class.licenses.where(user: user).first ||
    licenses.build(user: user)
  end

  def available_for_purchase?
    !finished && (series && series.round_cost != 0)
  end

  def license_cost
    if series
      series.round_cost
    else
      0
    end
  end

  def create_paid_license(user, stripe_charge_id)
    if free_license = licenses.where(user: user, paid: false).first
      free_license.paid = true
      free_license.stripe_charge_id = stripe_charge_id
      free_license.save!
    else
      licenses.create! user: user, stripe_charge_id: stripe_charge_id, paid: true
    end
  end

  def start_computing_score
    self.delay.compute_score
  end

  def compute_score
    return unless finished?

    users.uniq.each do |user|
      stats = user.user_round_stats.where(round: self).first_or_create

      stats.assign_attributes(
        rider_score: 0,
        heat_winner_score: 0,
        pole_position_score: 0,
        hole_shot_score: 0,
        total: 0,
        series: series,
        race_class: race_class,
        paid_race_class_license: race_class.registered_and_paid?(user),
        paid_round_license: registered_and_paid?(user),
        custom_series_ids: []
      )

      # Compute rider score
      user.rider_positions.where(round: self).each do |rider_position|
        next unless rider_position.rider.present?
        round_rider = round_riders.find_by(rider: rider_position.rider)
        next unless round_rider.present?
        score = rider_score(rider_position.position, round_rider.finished_position)
        rider_position.update_attributes(score: score)
        stats.rider_score += score        
      end

      # Compute bonus score
      user.user_round_bonus_selections.where(round: self).each do |selection|
        next unless selection.rider.present?
        type = selection.bonus_type.name
        value = selection.bonus_type.value
        value = bonus_winners_of_type(type).flat_map(&:rider).include?(selection.rider) ? value : -value
        field = "#{type.titleize.downcase.gsub(' ', '_')}_score"
        stats.assign_attributes(field => value)
      end

      # add users custom series id's to this stat so that it will count toward those series 
      stats.custom_series_ids = user.custom_series_ids(race_class.series) 

      stats.save
    end
  end

  def rider_score(user_position, actual_position)
    return 0 unless user_position && actual_position
    distance = position_distance(user_position, actual_position)      
    if distance == 0 
      return score_for_actual_position(user_position)
    else
      return score_for_distance_away(distance)
    end
  end

  def position_distance(user_position, actual_position)
    (user_position - actual_position).abs
  end

  def score_for_actual_position(position)
    return 0 if position > 22 || position < 1
    if position < 5
      return 50 - (2 * (position-1))
    else
      return 47 - position
    end
  end

  def score_for_distance_away(distance)
    return 0 if distance > 22 || distance < 1
    if distance < 4
      return 22 - (2 * (distance-1))
    else
      return 21 - distance
    end
  end

  def bonus_selection_open?(bonus_type)
    if bonus_type.name == "PolePosition"
      Time.now.between?(pole_position_start, pole_position_end) if (pole_position_start && pole_position_end)
    else
      true
    end
  end

  def to_s
    name
  end

  def to_param
    "#{id}-#{to_s.parameterize}"
  end
end
