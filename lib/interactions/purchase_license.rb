module Interactions
  class ExistingLicenseError < StandardError; end
  class UnavailablePurchaseError < StandardError; end

  class PurchaseLicense
    attr_reader :user
    attr_reader :licensable
    attr_reader :stripe_token


    def initialize(user, licensable, stripe_token)
      @user = user
      @licensable = licensable
      @stripe_token = stripe_token
    end

    def perform
      check_for_licensable_availability
      check_for_existing_paid_license
      create_or_update_stripe_customer
      create_stripe_charge
    end

    private

    def check_for_licensable_availability
      raise UnavailablePurchaseError unless licensable.available_for_purchase?
    end

    def check_for_existing_paid_license
      raise ExistingLicenseError if licensable.registered_and_paid? user
    end

    def create_or_update_stripe_customer
      if user.stripe_customer_id
        update_stripe_customer
      else
        create_stripe_customer
      end
    end

    def update_stripe_customer
      customer = Stripe::Customer.retrieve user.stripe_customer_id
      customer.card = stripe_token
      customer.save
    end

    def create_stripe_customer
      customer = Stripe::Customer.create email: user.email,
                                         card: stripe_token
      user.stripe_customer_id = customer.id
      user.save!
    end

    def create_stripe_charge
      charge = Stripe::Charge.create customer: user.stripe_customer_id,
                                     amount: licensable.license_cost,
                                     description: 'MotoDynasty',
                                     currency: 'usd'
      create_license charge.id
    end

    def create_license(stripe_charge_id)
      licensable.create_paid_license user, stripe_charge_id
    end

  end
end
