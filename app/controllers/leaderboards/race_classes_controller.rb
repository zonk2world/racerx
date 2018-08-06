class Leaderboards::RaceClassesController < Leaderboards::BaseController
  private
  def race_class
    @race_class ||= params[:id] && series.race_classes.find(params[:id])
  end

  def ancestors
    [:leaderboards, series]
  end

  def current
    race_class
  end

  def siblings
    series.race_classes
  end

  def children
    race_class.rounds.finished
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

  def prize_eligible?
    true
  end

  def canonical_path(options = {})
    leaderboards_series_race_class_path series, race_class, options
  end
end
