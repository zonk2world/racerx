class Leaderboards::SeriesController < Leaderboards::BaseController
  private
  def series
    @series ||= params[:id] && Series.find(params[:id])
  end

  def ancestors
    [:leaderboards]
  end

  def current
    series
  end

  def siblings
    Series.all
  end

  def children
    series.race_classes
  end

  def class_list
    series.race_classes
  end
  def series_name
    series.name
  end

  def canonical_path(options = {})
    leaderboards_series_path series, options
  end
end
