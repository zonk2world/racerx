require 'spec_helper'

module Interactions
  describe PurchaseLicense do
    describe "#perform" do
      subject { PurchaseLicense.new user, licensable, stripe_token }
      let(:user) { FactoryGirl.create :user }
      let(:licensable) { double("licensable") }
      let(:stripe_token) { "test_token" }
      let(:customer_double) { double("customer") }
      let(:charge_double) { double("charge") }

      before do
        allow(Stripe::Customer).to receive(:create).and_return customer_double
        allow(Stripe::Customer).to receive(:retrieve).and_return customer_double
        allow(Stripe::Charge).to receive(:create).and_return charge_double
        allow(customer_double).to receive(:id).and_return "customer_id"
        allow(customer_double).to receive(:save)
        allow(customer_double).to receive(:card=)
        allow(charge_double).to receive(:id).and_return('charge_id')
        allow(licensable).to receive(:license_cost).and_return "100"
        allow(licensable).to receive(:create_paid_license).with(user, 'charge_id')
        allow(licensable).to receive(:registered_and_paid?).and_return(false)
        allow(licensable).to receive(:available_for_purchase?).and_return(true)
      end

      describe "when the purchasing user has already purchased a paid license" do
        it "raises an error" do
          expect(licensable).to receive(:registered_and_paid?)
                                .with(user)
                                .and_return(true)
          expect { subject.perform }.to raise_error ExistingLicenseError
        end
      end

      describe "when the purchasing user has no stripe customer ID" do
        it "creates a new stripe customer" do
          expect(Stripe::Customer).to receive(:create)
                                      .with(email: user.email, card: stripe_token)
                                      .and_return customer_double
          subject.perform
        end

        it "sets the customer ID on the user" do
          expect(user.stripe_customer_id).to be_nil
          subject.perform
          expect(user.stripe_customer_id).to eq "customer_id"
        end

        it "creates a new stripe Charge in the amount given by licensable" do
          expect(Stripe::Charge).to receive(:create)
                                   .with(customer: "customer_id",
                                         amount: "100",
                                         description: "MotoDynasty",
                                         currency: "usd")
                                   .and_return charge_double
          subject.perform
        end
      end

      describe "when the purchasing user has a stripe customer ID" do
        before do
          user.update_attribute :stripe_customer_id, "customer_id"
        end

        it "does not create a stripe customer ID if one exists" do
          expect(Stripe::Customer).to_not receive(:create)
          subject.perform
        end

        it "updates the credit card token for the customer" do
          expect(Stripe::Customer).to receive(:retrieve)
                                      .with("customer_id")
                                      .and_return(customer_double)
          expect(customer_double).to receive(:card=).with stripe_token
          expect(customer_double).to receive(:save)
          subject.perform
        end

      end

      describe "when the licensable object isn't available for purchase" do
        it "raises an error" do
          expect(licensable).to receive(:available_for_purchase?).and_return false
          expect { subject.perform }.to raise_error UnavailablePurchaseError
        end
      end
    end
  end
end
