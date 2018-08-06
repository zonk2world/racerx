module Leaderboards
  class BaseController < ApplicationController
    before_filter :require_canonical_path

    private
    def series
      @series ||= params[:series_id] && Series.find(params[:series_id])
    end

    def race_class
      @race_class ||= params[:race_class_id] && series.race_classes.find(params[:race_class_id])
    end

    def round
      @round ||= params[:round_id] && race_class.rounds.find(params[:round_id])
    end

    def custom_series
      if series
        @custom_series ||= params[:custom_series_id] && series.custom_series.find(params[:custom_series_id])
      end
    end

    def leaderboard
      @leaderboard = LeaderBoardPresenter.new series: series, race_class: race_class, 
                                              round: round, custom_series: custom_series, 
                                              prize_filter: prize_filter, view: self
    end
    helper_method :leaderboard

    def ancestors
      []
    end

    def current
      :leaderboards
    end

    def siblings
      []
    end

    def children
      Series.all
    end

    def series_list
      Series.all
    end
    def class_list
      []
    end
    def round_list
      []
    end
    def series_ancestor
      [:leaderboards]
    end
    def class_ancestor
      [:leaderboards, series]
    end
    def round_anchestor
      [:leaderboards, series, race_class]
    end
    def series_name
      'SERIES'
    end
    def class_name
      'CLASS'
    end
    def round_name
      'ROUND'
    end

    helper_method :ancestors, :current, :siblings, :children
    helper_method :series_list, :class_list, :round_list, :series_ancestor, :class_ancestor, :round_anchestor, :series_name, :class_name, :round_name

    def prize_eligible?
      false
    end

    def prize_filter
      params[:prize_filter] == 'true'
    end

    helper_method :prize_eligible?, :prize_filter

    def canonical_path(options = {})
      leaderboards_path(options)
    end

    helper_method :canonical_path

    def require_canonical_path
      unless canonical_path == request.path
        redirect_to canonical_path, status: :moved_permanently
      end
    end
  end
end
