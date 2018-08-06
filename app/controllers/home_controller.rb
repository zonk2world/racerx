class HomeController < ApplicationController
  include ApplicationHelper

  def index
    series_name = settings_for('home_leaderboard_series')
    raceclass_name = settings_for('home_leaderboard_raceclass')
    round_name = settings_for('home_leaderboard_round')

    series = nil
    if series_name.present?
      series = Series.find_by(name: series_name)
    end

    race_class = nil
    if raceclass_name.present? and series.present?
      race_class = RaceClass.find_by(name: raceclass_name, series_id: series.id)
    end

    round = nil
    if round_name.present? and race_class.present?
      round = Round.find_by(name: round_name, race_class_id: race_class.id)
    end
    
    leaderboard = LeaderBoardPresenter.new series: series, race_class: race_class, 
                                            round: round, custom_series: nil, 
                                            prize_filter: false, view: self

    @sx_leaderboard = leaderboard.page.order('total desc').first(10)
    @sx_leaderboard = [] if @sx_leaderboard.nil?
  end

  def instructions
  end

end
