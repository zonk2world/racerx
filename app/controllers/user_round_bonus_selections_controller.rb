class UserRoundBonusSelectionsController < ApplicationController
  before_filter :set_variables

  respond_to :json

  def create
    user_selection = current_user.user_round_bonus_selections.build(user_round_bonus_selection_params)
    if user_selection.round.end_time > Time.now
      if user_selection.save
        render 'rider_positions/update_riders'
      else
        render nothing: true
      end
    else
      render nothing: true, status: 400
    end
  end

  def destroy
    user_selection = UserRoundBonusSelection.find(params[:id])
    if user_selection.round.end_time > Time.now
      if user_selection.destroy
        render 'rider_positions/update_riders'
      else
        render nothing: true
      end
    else
      render nothing: true, status: 400
    end
  end

protected
  def user_round_bonus_selection_params
    params.require(:user_round_bonus_selection).permit(:round_id, :rider_id, :bonus_type_id)
  end

  def set_variables
    race_class = RaceClass.find(params[:race_class])
    @presenter = UpdateRidersPresenter.new(params[:div_id], race_class)
  end
end
