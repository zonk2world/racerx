class Leaderboards::RoundsController < Leaderboards::BaseController
  private
  def round
    @round ||= params[:id] && race_class.rounds.finished.find(params[:id])
  end

  def ancestors
    [:leaderboards, series, race_class]
  end

  def current
    round
  end

  def siblings
    race_class.rounds.finished
  end

  def children
    []
  end

  def class_list
    series.race_classes
  end
  def round_list
    race_class.rounds.finished
  end
  def series_name
    series.name
  end
  def class_name
    race_class.name
  end
  def round_name
    round.name
  end

  def prize_eligible?
    true
  end

  def canonical_path(options = {})
    leaderboards_series_race_class_round_path series, race_class, round, options
  end
end
