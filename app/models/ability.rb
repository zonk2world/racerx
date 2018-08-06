class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.admin?
      can :manage, :all
      can :access, :rails_admin 
      can :generate_series, Series
    else
      can :read, Series
      can :read, Round
      can :read, Rider
      can :read, Team
      can :manage, UserMessage

      can :manage, CustomSeries do |passed_series|
        passed_series.try(:owner) == user
      end

      can :manage, User do |passed_user|
        passed_user.try(:id) == user.id
      end

      can :destroy, CustomSeriesLicense do |license|
        series_owner_id = license.custom_series.user_id
        (series_owner_id == user.id) && (license.user_id != user.id)
      end
      
      can :destroy, CustomSeriesInvitation do |invitation|
        (invitation.sender_id == user.id) || (invitation.recipient_email == user.email)
      end
    end
  end
end
