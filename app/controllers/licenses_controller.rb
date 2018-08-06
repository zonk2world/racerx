class LicensesController < ApplicationController  
  before_action :find_licensable

  def new
  end

  def create
    if params[:paid]
      purchase = Interactions::PurchaseLicense.new current_user,
                                                   @licensable,
                                                   params[:stripeToken]
      purchase.perform
      redirect_to current_user, notice: "Registration succeeded."
    else
      @license = current_user.licenses.build(license_params)
      if @license.save
        redirect_to current_user, notice: "Registration succeeded."
      else 
        redirect_to series, notice: "Registration unsuccessful."
      end
    end
  rescue Interactions::ExistingLicenseError
    redirect_to current_user, notice: "You have already purchased this license."
  rescue Interactions::UnavailablePurchaseError
    redirect_to current_user, notice: "This license is no longer available for purchase."
  rescue Stripe::CardError => e
    redirect_to new_race_class_license_path(@licensable), error: e.message
  end

protected 

  def license_params
    params.require(:license).permit(:user_id, :licensable_id, :licensable_type, :paid)
  end

  def find_licensable
    if params[:race_class_id]
      @licensable = RaceClass.find params[:race_class_id]
    elsif params[:round_id]
      @licensable = Round.find params[:round_id]
    else
      redirect_to :back, error: "Something unexpected occurred. Please try again later."
    end
  end
end
