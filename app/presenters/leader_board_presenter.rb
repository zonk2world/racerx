require 'ostruct'

class LeaderBoardPresenter < OpenStruct # series, race_class, round, custom_series, prize_filter, view
  def data
    @data ||= leader_board_with_rank_query
  end

  def for_user user
    data.where(user: user).take
  end

  def search
    @search ||= data.search(params[:q])
  end

  def page
    @page ||= search.result.page(params[:page])
  end

  private
  def params
    view.params
  end

  def custom_series_id
    custom_series ?  custom_series.id : false
  end

  def where_query
    {
      series: series,
      race_class: race_class,
      round: round
    }.delete_if {|k,v| v.blank?}
  end

  def leader_board_query
    UserRoundStat.select(
      :user_id,
      'max(id) as id', # AR assumes there will be an id, close enough
      'sum(total) as total',
      'avg(total) as average'
    ).where(
      where_query
    ).where(
      'total IS NOT NULL'
    ).group(
      :user_id
    ).tap do |res|
      1
    end
  end

  def custom_series_leaderboard_query
    if custom_series_id.present?
      leader_board_query.where("#{custom_series_id} = ANY (custom_series_ids)")
    else
      leader_board_query
    end
  end

  def prize_filter_query
    if prize_filter && round.present?
      custom_series_leaderboard_query.where(paid_round_license: true)
    elsif prize_filter && race_class.present?
      custom_series_leaderboard_query.where(paid_race_class_license: true)
    else
      custom_series_leaderboard_query
    end
  end

  def leader_board_with_rank_query
    # Had to double up on subqueries to get order by rank to work from ransack
    # Annoying, but solves the problem and shouldn't actually hurt performance

    UserRoundStat.from("(#{
      UserRoundStat.select(
        '*',
        'rank() OVER (ORDER BY total DESC NULLS LAST) as rank',
      ).from(
        "(#{ prize_filter_query.to_sql }) as user_round_stats"
      ).order(
        'total DESC NULLS LAST'
      ).includes(
        :user
      ).to_sql
    }) as user_round_stats").includes(:user)
  end
end
