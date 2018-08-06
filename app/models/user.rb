class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :rider_positions, dependent: :destroy
  has_many :payments
  has_many :series_licenses, dependent: :destroy
  has_many :series, through: :series_licenses
  has_many :points, as: :pointable, dependent: :destroy
  has_many :user_round_bonus_selections, dependent: :destroy
  has_many :user_round_stats, dependent: :destroy
  has_many :owned_series, class_name: 'CustomSeries', dependent: :destroy
  
  has_many :custom_series_licenses, dependent: :destroy
  has_many :custom_series, through: :custom_series_licenses

  has_many :licenses, dependent: :destroy

  def handle
    return email if username.blank?
    username
  end

  def remove_credits(amount)
    if self.credits >= amount
      self.credits -= amount
      self.save
    else
      raise "Not enough credits"
    end
  end

  def available_rider_position_for_round(round)
    #Change value to control the number of riders selected in each round.
    if rider_positions.where(round: round).count < 22
      rider_positions.new(round: round)
    else
      rider_positions.find_by(round: round, rider_id: nil)
    end
  end

  def available_riders_for_round(round)
    begin
      existing_riders = rider_positions.where(round: round).collect(&:rider).compact
      round.riders - existing_riders
    rescue
      {}
    end
  end

  def rider_positions_for_round(round)
    rider_positions.where(round: round).order('position ASC')
  end

  def order_riders_for_round(round)
    rider_positions.where(round: round).order('position').collect(&:rider)
  end

  def total_points
    user_round_stats.sum('total')
  end

  def total_points_for_round(round)
    rider_positions.where(round: round).to_a.sum(&:score)
  end

  def total_points_for_race_class(race_class)
    total_points = 0
    race_class.rounds.each do |round|
      total_points += total_points_for_round(round)
    end
    total_points
  end

  def bonus_selection_by_round_and_type(round, type)
    bonus_type = BonusType.find_by(name: type)
    user_round_bonus_selections.find_by(round_id: round.id, bonus_type_id: bonus_type.id)
  end

  def bonus_selection_available?(round, bonus_type)
    round.bonus_selection_open?(bonus_type)
  end

  def custom_series_ids(series)
    custom_series.where(series: series).collect(&:id)
  end

  def custom_series_for_series(series)
    custom_series.where(series: series)
  end

  def participant_in_round?(round)
    rider_positions_for_round(round).any?
  end

  def after_sign_in_path
    pending_invitations = CustomSeriesInvitation.where(recipient_email: email).order(created_at: :desc)
    if pending_invitations.empty?
      Rails.application.routes.url_helpers.user_path self
    else
      latest_invitation = pending_invitations.first
      Rails.application.routes.url_helpers.custom_series_path(latest_invitation.custom_series,
                                                              token: latest_invitation.token)
    end
  end

  def get_custom_series_invitations
    CustomSeriesInvitation.where(recipient_email: email).order(created_at: :desc)
  end

  def get_custom_series_requests
    #custom_series.map(&:custom_series_requests)
    requests = []
    custom_series.map{ |custom_series| requests = requests | custom_series.custom_series_requests }
    requests
  end

  def race_classes    
    licenses.map(&:race_class).uniq    
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :facebook_id => auth.uid).first
    puts '=== find_for_facebook_oauth ===', user.inspect
    if user && user.oauth_token.nil?
      user.update(oauth_token: auth.credentials.token, 
                  oauth_expires_at: Time.at(auth.credentials.expires_at))
    elsif !user
      puts '=== User ==='

      # user = User.create(name:auth.extra.raw_info.name,
      #                      provider:auth.provider,
      #                      facebook_id:auth.uid,
      #                      email:auth.info.email,
      #                      oauth_token: auth.credentials.token,
      #                      oauth_expires_at: Time.at(auth.credentials.expires_at),
      #                      password:Devise.friendly_token[0,20]
      #                      )
      puts auth.info.inspect
      user = User.find_by_email(auth.info.email)
      if !user
        user = User.new(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           facebook_id:auth.uid,
                           email:auth.info.email,
                           oauth_token: auth.credentials.token,
                           oauth_expires_at: Time.at(auth.credentials.expires_at),
                           password:Devise.friendly_token[0,20]
                           )
        if user.save
        else
          puts '==Error==', user.errors.full_messages
        end
      end

    end
    user
  end  
  def self.find_or_create_by_uid(uid, params)
    user = User.where(provider: 'facebook', facebook_id: uid.to_s).first
    unless user
      user = User.create(  name: params[:name],
                           provider: 'facebook',
                           facebook_id: facebook_id.to_s,
                           email: "#{facebook_id.to_s}@fb.com",
                           password: Devise.friendly_token[0,20]
                        )
    end
    user
  end   

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end  

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
    rescue Koala::Facebook::APIError => e
      logger.info e.to_s
      nil # or consider a custom null object
  end


end
