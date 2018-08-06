require 'spec_helper'

describe Round do
  let(:round) { FactoryGirl.create(:round)}
  let(:user) { FactoryGirl.create(:user)}

  context "associations" do
    it 'should belong to a race_class' do
      Round.reflect_on_association(:race_class).should_not be_nil
      Round.reflect_on_association(:race_class).macro.should eql(:belongs_to)
    end

    it 'should have many round_riders' do
      Round.reflect_on_association(:round_riders).should_not be_nil
      Round.reflect_on_association(:round_riders).macro.should eql(:has_many)
    end

    it 'should have many rider_positions' do
      Round.reflect_on_association(:rider_positions).should_not be_nil
      Round.reflect_on_association(:rider_positions).macro.should eql(:has_many)
    end

    it 'should delete round riders on delete' do
      round = FactoryGirl.create(:round)
      rider = FactoryGirl.create(:rider)
      round_rider = FactoryGirl.create(:round_rider, round: round, rider: rider)
      expect(round.round_riders.count).to eq 1
      round.destroy
      expect(round.round_riders.count).to eq 0
    end
  end

  context "validations" do
    it "should require a start_time" do
      FactoryGirl.build(:round, start_time: nil).should_not be_valid
    end

    it "should require an end_time" do
      FactoryGirl.build(:round, end_time: nil).should_not be_valid
    end

    context "round_bonus_winners_present" do 
      it "should be invalid without a heat winner" do
        round = FactoryGirl.create(:round_with_bonus_types_and_winners)
        round.bonus_winners_of_type("HeatWinner").first.destroy
        round.finished = true
        expect(round.save).to eq false
      end

      it "should be invalid without a heat winner" do
        round = FactoryGirl.create(:round_with_bonus_types_and_winners)
        round.bonus_winners_of_type("PolePosition").first.destroy
        round.finished = true
        expect(round.save).to eq false
      end

      it "should be invalid without a heat winner" do
        round = FactoryGirl.create(:round_with_bonus_types_and_winners)
        round.bonus_winners_of_type("HoleShot").first.destroy
        round.finished = true
        expect(round.save).to eq false
      end

      it "should be valid with a all the round bonus winners" do
        round = FactoryGirl.build(:round_with_bonus_types_and_winners)
        round.finished = true
        expect(round.save).to eq true
      end

      it "riders should not be able to be added to users rider positions more than once" do
        user = FactoryGirl.create(:user)
        round = FactoryGirl.create(:round)
        rider = FactoryGirl.create(:rider)
        FactoryGirl.create(:rider_position, user: user, round: round, rider: rider)
        expect(FactoryGirl.build(:rider_position, user: user, round: round, rider: rider)).to_not be_valid
      end
    end
  end

  describe ".current_for" do
    let(:race_class) { FactoryGirl.create(:race_class, rounds: [round1, round2, round3]) }
    let(:round1) { FactoryGirl.create(:round_with_bonus_types_and_winners) }
    let(:round2) { FactoryGirl.create(:round_with_bonus_types_and_winners, start_time: 1.week.ago, end_time: 1.hour.ago) }
    let(:round3) { FactoryGirl.create(:round_with_bonus_types_and_winners, start_time: Time.now, end_time: 1.week.from_now) }

    describe "#current_round" do       
      it 'should return all of the current_round' do 
        round1.finished = true
        round1.save
        expect(Round.current_for(race_class)).to eq round2
      end
    end
  end

  describe "#methods" do
    Delayed::Worker.delay_jobs = false
    before(:each) do
      [ 
        {name: 'HeatWinner', value: 15},
        {name: 'PolePosition', value: 5},
        {name: 'HoleShot', value: 20},
      ].each do |params|
        BonusType.find_or_create_by(params)
      end
    end

    describe "#bonus_winners_of_type" do
      context "no winners set" do 
        it 'should return an empty array' do 
          round.round_bonus_winners.destroy_all
          expect(round.bonus_winners_of_type("HeatWinner")).to eq []
        end
      end
    end

    def setup_series_race_class_and_round
      @user = FactoryGirl.create(:user)
      @series = FactoryGirl.create(:series)
      SeriesLicense.create(user: @user, series: @series)
      @race_class = FactoryGirl.create(:race_class, series: @series)
      @round = FactoryGirl.create(:round, race_class: @race_class)
      @rider1 = FactoryGirl.create(:rider)
      @rider2 = FactoryGirl.create(:rider)
      RoundRider.create(rider: @rider1, round: @round, finished_position: 1)
      RoundRider.create(rider: @rider2, round: @round, finished_position: 3)
      RiderPosition.create(round: @round, user: @user, rider: @rider1, position: 1)
      RiderPosition.create(round: @round, user: @user, rider: @rider2, position: 2)
      @round.round_bonus_winners.create(rider: @rider1, bonus_type: BonusType.find_by(name: 'HeatWinner'))
      @round.round_bonus_winners.create(rider: @rider1, bonus_type: BonusType.find_by(name: 'PolePosition'))
      @round.round_bonus_winners.create(rider: @rider1, bonus_type: BonusType.find_by(name: 'HoleShot'))
      @custom_series = FactoryGirl.create(:custom_series, owner: @user, series: @series)
      FactoryGirl.create(:custom_series_license, user: @user, custom_series: @custom_series)
    end

    describe "#compute_score" do
      before(:each) do
        setup_series_race_class_and_round
        @second_custom_series = FactoryGirl.create(:custom_series, owner: @user, series: @series)
        FactoryGirl.create(:custom_series_license, user: @user, custom_series: @second_custom_series)
        @round.finished = true
        @round.save
      end

      it 'should give me partial score the closer I am to correct placement' do
        @round.rider_positions.last.score.should == 22
      end

      it 'should create points for the rider' do
        expect(@rider1.points_total).to eq 50
        expect(@rider2.points_total).to eq 22
      end

      context "user_round_stats" do 
        it 'should create a user_round_stat for each user' do 
          expect(@user.user_round_stats.count).to eq 1
        end

        it 'should have the correct total rider score a user_round_stat for each user' do 
          expect(@user.user_round_stats.find_by(round: @round).rider_score).to eq 72
        end

        it 'should add all of the users custom_series_ids to this user_round_stats' do 
          ids = @user.user_round_stats.find_by(round: @round).custom_series_ids
          expect(ids).to include @custom_series.id
          expect(ids).to include @second_custom_series.id
        end

        context 'bonus stats' do 
          context "correct picks" do 
            before(:each) do
              setup_series_race_class_and_round
              @user.user_round_bonus_selections.create(round: @round, rider: @rider1, bonus_type: BonusType.find_by(name: 'HeatWinner'))
              @user.user_round_bonus_selections.create(round: @round, rider: @rider1, bonus_type: BonusType.find_by(name: 'PolePosition'))
              @user.user_round_bonus_selections.create(round: @round, rider: @rider1, bonus_type: BonusType.find_by(name: 'HoleShot'))
              @round.finished = true
              @round.save
            end

            it 'should add to to stat total for correct guesses' do 
              expect(@user.user_round_stats.find_by(round: @round).heat_winner_score).to eq 15
              expect(@user.user_round_stats.find_by(round: @round).pole_position_score).to eq 5
              expect(@user.user_round_stats.find_by(round: @round).hole_shot_score).to eq 20
            end
          end

          context "incorrect picks" do 
            before(:each) do
              setup_series_race_class_and_round
              @user.user_round_bonus_selections.create(round: @round, rider: @rider2, bonus_type: BonusType.find_by(name: 'HeatWinner'))
              @user.user_round_bonus_selections.create(round: @round, rider: @rider2, bonus_type: BonusType.find_by(name: 'PolePosition'))
              @user.user_round_bonus_selections.create(round: @round, rider: @rider2, bonus_type: BonusType.find_by(name: 'HoleShot'))
              @round.finished = true
              @round.save
            end

            it 'should subtract stat total for incorrect guesses' do 
              expect(@user.user_round_stats.find_by(round: @round).heat_winner_score).to eq -15
              expect(@user.user_round_stats.find_by(round: @round).pole_position_score).to eq -5
              expect(@user.user_round_stats.find_by(round: @round).hole_shot_score).to eq -20
            end
          end
        end
      end
    end

    describe "#rider_score" do
      it 'should return the correct score' do
        round.rider_score(1, 3).should == 20
        round.rider_score(1, 21).should == 1
        round.rider_score(1, 1).should == 50
        round.rider_score(1, 2).should == 22
        round.rider_score(2, 2).should == 48
        round.rider_score(2, 4).should == 20
      end
    end

    describe "#position_distance" do
      it 'should return the correct distance' do
        round.position_distance(1, 1).should == 0
        round.position_distance(1, 2).should == 1
        round.position_distance(3, 1).should == 2
        round.position_distance(2, 7).should == 5
      end
    end

    describe "#score_for_actual_position" do
      it 'should return the correct score' do
        round.score_for_actual_position(1).should == 50
        round.score_for_actual_position(2).should == 48
        round.score_for_actual_position(6).should == 41
        round.score_for_actual_position(7).should == 40
        round.score_for_actual_position(22).should == 25
      end

      it 'should returns 0 for out of bounds scores' do
        round.score_for_actual_position(-1).should == 0
        round.score_for_actual_position(23).should == 0
      end
    end

    describe "#rider_selection_open?" do
      it 'should be true if within start_time and end_time' do
        round.start_time = 5.days.ago
        round.end_time = 2.days.from_now
        round.rider_selection_open?.should == true
      end

      it 'should be false if time is before start time' do
        round.start_time = 1.hour.from_now
        round.end_time = 2.days.from_now
        round.rider_selection_open?.should == false
      end

      it 'should be false if time is after end time' do
        round.start_time = 1.day.ago
        round.end_time = 1.hour.ago
        round.rider_selection_open?.should == false
      end
    end

    describe "#round_riders_where_finished_is" do
      let(:rider1) {FactoryGirl.create(:rider, name: "Rider 1")}
      let(:rider2) {FactoryGirl.create(:rider, name: "Rider 2")}
      let(:finished_round_rider) {RoundRider.create(rider: rider1, round: round, finished_position: 1)}
      let(:unfinished_round_rider) {RoundRider.create(rider: rider2, round: round)}

      it 'should return finished riders' do
        expect(round.round_riders_where_finished_is(true)).to eq [finished_round_rider]
      end

      it 'should return unfinished riders' do
        expect(round.round_riders_where_finished_is(false)).to eq [unfinished_round_rider]
      end
    end

    describe "#bonus_selection_open?" do
      let(:round) {FactoryGirl.create(:round_with_bonus_types_and_winners, pole_position_start: nil, pole_position_end: nil)}

      it 'should be nil if time not selected' do
        expect(round.bonus_selection_open?(BonusType.find_by(name: "PolePosition"))).to eq nil
      end

      it 'should return true if within the pole position times' do
        round.pole_position_start = 1.hour.ago
        round.pole_position_end = 1.hour.from_now
        round.save
        expect(round.bonus_selection_open?(BonusType.find_by(name: "PolePosition"))).to eq true
      end
    end

    describe "#registered_and_paid?" do
      let(:user) { FactoryGirl.create :user }
      let(:paid_user) { FactoryGirl.create :user }
      let(:another_user) { FactoryGirl.create :user }
      let(:round) { FactoryGirl.create :round }
      let!(:license) { FactoryGirl.create :license, user: user, licensable: round }
      let!(:paid_license) { FactoryGirl.create :license, user: paid_user,
                                                         licensable: round,
                                                         paid: true }

      it "returns true if the user has a paid license" do
        expect(round.registered_and_paid? paid_user).to be true
      end

      it "returns false if the user has a free license" do
        expect(round.registered_and_paid? user).to be false
      end

      it "returns false if the user has no license" do
        expect(round.registered_and_paid? another_user).to be false
      end

      it "returns true if the user has the paid parent race class license" do
        FactoryGirl.create :license, user: another_user,
                                     licensable: round.race_class,
                                     paid: true
        expect(round.registered_and_paid? another_user).to be true
      end

      it "returns false if the user only has the free parent race class license" do
        FactoryGirl.create :license, user: another_user,
                                     licensable: round.race_class,
                                     paid: false
        expect(round.registered_and_paid? another_user).to be false
      end
    end


    describe "#unpaid_license?" do
      let(:user) { FactoryGirl.create :user }
      let(:paid_user) { FactoryGirl.create :user }
      let(:another_user) { FactoryGirl.create :user }
      let(:round) { FactoryGirl.create :round }
      let!(:license) { FactoryGirl.create :license, user: user, licensable: round }
      let!(:paid_license) { FactoryGirl.create :license, user: paid_user,
                                                         licensable: round,
                                                         paid: true }

      it "returns false if the user has a paid license" do
        expect(round.unpaid_license? paid_user).to be false 
      end

      it "returns true if the user has a free license" do
        expect(round.unpaid_license? user).to be true
      end

      it "returns false if the user has no license" do
        expect(round.unpaid_license? another_user).to be false
      end

      it "returns true if the user only has the free parent race class license" do
        FactoryGirl.create :license, user: another_user,
                                     licensable: round.race_class,
                                     paid: false
        expect(round.unpaid_license? another_user).to be true
      end

      it "returns false if the user has a paid round license and the free parent race class license" do
        FactoryGirl.create :license, user: paid_user,
                                     licensable: round.race_class,
                                     paid: false
        expect(round.unpaid_license? paid_user).to be false
      end

      it "returns false if the user has a free round license and a paid parent race class license" do
        FactoryGirl.create :license, user: user,
                                     licensable: round.race_class,
                                     paid: true
        expect(round.unpaid_license? user).to be false
      end
    end

    describe "#license_for" do
      let(:user) { FactoryGirl.create :user }
      let(:another_user) { FactoryGirl.create :user }
      let(:round) { FactoryGirl.create :round }
      let!(:license) { FactoryGirl.create :license, user: user, licensable: round }

      it "returns the license for a given user" do
        expect(round.license_for user).to eq license
      end

      it "returns the parent series license if it exists" do
        parent_license = FactoryGirl.create :license, user: another_user,
                                     licensable: round.race_class,
                                     paid: true
        expect(round.license_for another_user).to eq parent_license
      end

      it "returns a new free round license for users without a license" do
        new_license = round.license_for another_user
        expect(new_license).to_not be_persisted
        expect(new_license.licensable).to eq round
        expect(new_license.paid).to eq false
        expect(new_license.user).to eq another_user
      end
    end

    describe "#registered?" do
      let(:user) { FactoryGirl.create :user }
      let(:another_user) { FactoryGirl.create :user }
      let(:round) { FactoryGirl.create :round }

      describe "when the user doesn't have a license" do
        it "returns false" do
          expect(round.registered? user).to be false
        end
      end

      describe "when the user has the round's round license" do
        let!(:round_license) { FactoryGirl.create :license, user: user, licensable: round }

        it "returns true" do
          expect(round.registered? user).to be true
        end
      end

      describe "when the user has the round's race class license" do
        let!(:race_class_license) { FactoryGirl.create :license, user: user, licensable: round.race_class }

        it "returns true" do
          expect(round.registered? user).to be true
        end
      end
    end

    describe "#license_cost" do
      it "returns the per-round cost for the series" do
        expect(round.license_cost).to eq 50
      end
    end

    describe "#create_paid_license" do
      let(:user) { FactoryGirl.create :user }
      let(:round) { FactoryGirl.create :round }

      it "creates a paid license for the round" do
        expect(License.where user: user, licensable: round).to be_empty
        round.create_paid_license user, 'charge_id'
        license = License.where(user: user, licensable: round).first
        expect(license.paid).to be true
      end

      describe "if the user already has a free round license" do
        let!(:free_license) { FactoryGirl.create :license, user: user, licensable: round }

        it "upgrades the license to paid" do
          expect(round.license_for(user).paid).to be false
          round.create_paid_license user, 'charge_id'
          expect(round.license_for(user).paid).to be true
        end

        it "records the stripe charge id associated with the upgrade" do
          expect(round.license_for(user).stripe_charge_id).to be_nil
          round.create_paid_license user, 'charge_id'
          expect(round.license_for(user).stripe_charge_id).to eq 'charge_id'
        end

        it "reuses the free license record" do
          round.create_paid_license user, 'charge_id'
          expect(round.license_for(user).id).to eq free_license.id
        end
      end
    end

    describe "#available_for_purchase?" do
      describe "when the round is unfinished" do
        let(:round) { FactoryGirl.build :round }

        it "returns true" do
          expect(round.available_for_purchase?).to be true
        end
      end

      describe "when the round has a cost of 0" do
        let(:round) { FactoryGirl.build :round }
        before { round.series.update_attribute :round_cost, 0 }

        it "returns false" do
          expect(round.available_for_purchase?).to be false
        end
      end

      describe "when the round is finished" do
        let(:round) { FactoryGirl.build :round, finished: true }

        it "returns false" do
          expect(round.available_for_purchase?).to be false
        end
      end
    end
  end
end
