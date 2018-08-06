class UsersController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def sort_rider
    round_id = params[:round_id]
    round = Round.find(round_id)
    if round.end_time > Time.now
      params[:sortable].each_with_index do |rider, index|
        rider_position_id = rider.gsub('rider_position_', '').to_i
        rider_position = RiderPosition.find(rider_position_id)
        rider_position.position = index+1
        rider_position.save if rider_position.changed?
      end
      render nothing: true
    else
      render nothing: true, status: 400
    end
  end
end
