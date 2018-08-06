require 'spec_helper'

describe RaceClass do
  context "associations" do
    it 'should belong to a series' do
      RaceClass.reflect_on_association(:series).should_not be_nil
      RaceClass.reflect_on_association(:series).macro.should eql(:belongs_to)
    end

    it 'should have many rounds' do
      RaceClass.reflect_on_association(:rounds).should_not be_nil
      RaceClass.reflect_on_association(:rounds).macro.should eql(:has_many)
    end
  end

  describe "#methods" do
    describe "#registered?" do
      let(:user) { FactoryGirl.create :user }
      let(:another_user) { FactoryGirl.create :user }
      let(:race_class) { FactoryGirl.create :race_class }
      let!(:license) { FactoryGirl.create :license, user: user, licensable: race_class }

      it "returns true if the user is registered for a race class" do
        expect(race_class.registered? user).to be true
      end

      it "returns false if the user isn't registered for a race class" do
        expect(race_class.registered? another_user).to be false
      end
    end

    describe "#registered_and_paid?" do
      let(:user) { FactoryGirl.create :user }
      let(:paid_user) { FactoryGirl.create :user }
      let(:another_user) { FactoryGirl.create :user }
      let(:race_class) { FactoryGirl.create :race_class }
      let!(:license) { FactoryGirl.create :license, user: user, licensable: race_class }
      let!(:paid_license) { FactoryGirl.create :license, user: paid_user,
                                                         licensable: race_class,
                                                         paid: true }

      it "returns true if the user has a paid license" do
        expect(race_class.registered_and_paid? paid_user).to be true
      end

      it "returns false if the user has a free license" do
        expect(race_class.registered_and_paid? user).to be false
      end

      it "returns false if the user has no license" do
        expect(race_class.registered_and_paid? another_user).to be false
      end
    end

    describe "#unpaid_license?" do
      let(:user) { FactoryGirl.create :user }
      let(:paid_user) { FactoryGirl.create :user }
      let(:another_user) { FactoryGirl.create :user }
      let(:race_class) { FactoryGirl.create :race_class }
      let!(:license) { FactoryGirl.create :license, user: user, licensable: race_class }
      let!(:paid_license) { FactoryGirl.create :license, user: paid_user,
                                                         licensable: race_class,
                                                         paid: true }

      it "returns false if the user has a paid license" do
        expect(race_class.unpaid_license? paid_user).to be false 
      end

      it "returns true if the user has a free license" do
        expect(race_class.unpaid_license? user).to be true
      end

      it "returns false if the user has no license" do
        expect(race_class.unpaid_license? another_user).to be false
      end
    end

    describe "#license_for" do
      let(:user) { FactoryGirl.create :user }
      let(:another_user) { FactoryGirl.create :user }
      let(:race_class) { FactoryGirl.create :race_class }
      let!(:license) { FactoryGirl.create :license, user: user, licensable: race_class }

      it "returns the license for a given user" do
        expect(race_class.license_for user).to eq license
      end

      it "returns a new license for users without a license" do
        new_license = race_class.license_for another_user
        expect(new_license).to_not be_persisted
        expect(new_license.licensable).to eq race_class
        expect(new_license.user).to eq another_user
      end
    end

    describe "#license_cost" do
      let(:race_class) { FactoryGirl.create :race_class }
      let(:expensive_series) { Series.create name: "Expensive Series", cost: 300 }
      let(:another_race_class) { expensive_series.race_classes.create! name: "Another Class" }

      it "returns the cost of the parent series" do
        expect(race_class.license_cost).to eq 100
        expect(another_race_class.license_cost).to eq 300
      end
    end

    describe "#create_paid_license" do
      let(:user) { FactoryGirl.create :user }
      let(:round_one) { FactoryGirl.create :round }
      let(:race_class) { round_one.race_class }

      it "creates a paid license for the race class" do
        expect(License.where user: user, licensable: race_class).to be_empty
        race_class.create_paid_license user, 'charge_id'
        license = License.where(user: user, licensable: race_class).first
        expect(license.paid).to be true
      end

      describe "if the user already has a free license" do
        let!(:free_license) { FactoryGirl.create :license, user: user, licensable: race_class }

        it "upgrades the license to paid" do
          expect(race_class.license_for(user).paid).to be false
          race_class.create_paid_license user, 'charge_id'
          expect(race_class.license_for(user).paid).to be true
        end

        it "records the stripe charge id associated with the upgrade" do
          expect(race_class.license_for(user).stripe_charge_id).to be_nil
          race_class.create_paid_license user, 'charge_id'
          expect(race_class.license_for(user).stripe_charge_id).to eq 'charge_id'
        end

        it "reuses the free license record" do
          race_class.create_paid_license user, 'charge_id'
          expect(race_class.license_for(user).id).to eq free_license.id
        end
      end

      describe "if the user already has points in the race class" do
        let!(:user_round_stat) { FactoryGirl.create :user_round_stat,
                                                   user: user,
                                                   round: round_one,
                                                   race_class: race_class,
                                                   series: race_class.series }
        it "updates the existing user round stats for the race class to show a paid race class license" do
          expect(user_round_stat.paid_race_class_license).to be false
          race_class.create_paid_license user, 'charge_id'
          user_round_stat.reload
          expect(user_round_stat.paid_race_class_license).to be true
        end

        it "does not update the paid_round_license flag of existing user round stats" do
          expect(user_round_stat.paid_round_license).to be false
          race_class.create_paid_license user, 'charge_id'
          user_round_stat.reload
          expect(user_round_stat.paid_round_license).to be false
        end
      end
    end

    describe "#available_for_purchase?" do
      let(:round_one) { FactoryGirl.create :round }
      let(:race_class) { round_one.race_class }
      let!(:round_two) { FactoryGirl.create :round, race_class: race_class}

      describe "when the race class has an unfinished round" do
        before do
          round_one.update_attribute :finished, true
        end

        it "returns true" do
          expect(race_class.available_for_purchase?).to be true
        end
      end

      describe "when the race class has no unfinished rounds" do
        before do
          round_one.update_attribute :finished, true
          round_two.update_attribute :finished, true
        end

        it "returns false" do
          expect(race_class.available_for_purchase?).to be false
        end
      end

      describe "when the race class license costs nothing" do
        before { race_class.series.update_attribute :cost, 0 }

        it "returns false" do
          expect(race_class.available_for_purchase?).to be false
        end
      end
    end

  end
end
