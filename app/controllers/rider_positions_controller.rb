class RiderPositionsController < ApplicationController
  respond_to :json

  def create
    rider_position = current_user.rider_positions.build(rider_position_params)
    if rider_position.round.end_time > Time.now
      current_count = current_user.rider_positions.where(round_id: rider_position.round_id).count
      rider_position.position = current_count + 1
      if rider_position.save
        setup_presenter(rider_position)
        render 'update_riders'
      else
        render nothing: true
      end
    else
      render nothing: true, status: 400
    end
  end

  def update
    rider_position = RiderPosition.find(params[:id])
    if rider_position.round.end_time > Time.now
      if rider_position.update(rider_position_params)
        setup_presenter(rider_position)
        render 'update_riders'
      else
        render nothing: true
      end
    else
      render nothing: true, status: 400
    end
  end

  def update_with_lastweek_riders

    round = Round.find(params[:rider_position][:round_id])
    pre_round = Round.last_week_round(round.race_class)
    puts "----- update_with_lastweek_riders ---"
    puts "== round.id : #{round.id} =="
    puts "== pre_round.id : #{pre_round.id} =="
    if pre_round
      pre_round.rider_positions.each_with_index do |rider_position, index|
        build_rider_position round.id, rider_position.rider_id, index + 1
      end
      render 'update_riders'
    else
      render nothing: true, status: 400
    end
  end

  def destroy
    rider_position = RiderPosition.find(params[:id])
    if rider_position.round.end_time > Time.now
      setup_presenter(rider_position)
      if rider_position.destroy
        render 'update_riders'
      else
        render nothing: true
      end
    else
      render nothing: true, status: 400
    end
  end
private
  def build_rider_position round_id, rider_id, position
    rider_position = current_user.rider_positions.build({round_id: round_id, rider_id: rider_id, position: position})
    if rider_position.round.end_time > Time.now
      current_count = current_user.rider_positions.where(round_id: rider_position.round_id).count
      rider_position.position = current_count + 1
      if rider_position.save
        setup_presenter(rider_position)    
      end
    end    
  end
protected
  def rider_position_params
    params.require(:rider_position).permit(:rider_id, :position, :round_id)
  end

  def setup_presenter(rider_position)
    @presenter = UpdateRidersPresenter.new(params[:div_id], rider_position.round.race_class)
  end
end
