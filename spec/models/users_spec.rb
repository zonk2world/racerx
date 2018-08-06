require 'spec_helper'

describe User do

  context "associations" do
    it 'should have many rider positions' do
      User.reflect_on_association(:rider_positions).should_not be_nil
      User.reflect_on_association(:rider_positions).macro.should eql(:has_many)
    end

    it 'should have many payments' do
      User.reflect_on_association(:payments).should_not be_nil
      User.reflect_on_association(:payments).macro.should eql(:has_many)
    end

    it 'should have many user_round_stats' do
      User.reflect_on_association(:user_round_stats).should_not be_nil
      User.reflect_on_association(:user_round_stats).macro.should eql(:has_many)
    end
  end

  describe "#methods" do 
    let(:user) { FactoryGirl.create(:user)}
    before(:each) do
      @round = FactoryGirl.create(:round)
      @rider = FactoryGirl.create(:rider)
      @rider2 = FactoryGirl.create(:rider) 
      RoundRider.create(round: @round, rider: @rider)
      RoundRider.create(round: @round, rider: @rider2)  
    end

    describe "#available_rider_position_for_round" do 
      it "should return a rider position with no rider" do 
        user.available_rider_position_for_round(@round).rider.should be_nil
      end

      it "should return nil if all rider positions are filled" do
        (1..22).each do |index|
          rider = FactoryGirl.build(:rider)
          user.rider_positions.create(round: @round, rider: rider, position: index)
        end
        expect(user.available_rider_position_for_round(@round)).to be_nil
      end
    end

    describe "#available_riders_for_round" do 
      it "should generate an rider position for each rider" do 
        user.available_riders_for_round(@round).should =~ [@rider, @rider2]
      end
    end

    describe "#total_points_for_round" do 
      it "should correctly total the score" do 
        RiderPosition.create(round: @round, user: user, rider: @rider2, score: 10)
        RiderPosition.create(round: @round, user: user, rider: @rider, score: 9)
        user.total_points_for_round(@round).should == 19
      end
    end

    describe "#points" do 
      it "should correctly total the users points" do 
        FactoryGirl.create(:payment, user: user, amount: 100)
        FactoryGirl.create(:payment, user: user, amount: 100)
        user.credits.should == 200
      end
    end

    describe "#handle" do 
      it "should show users email if no name present" do 
        FactoryGirl.create(:user, name: nil, email: "bill@murray.com").handle.should == "bill@murray.com"
      end

      it "should show users name if one is present" do 
        FactoryGirl.create(:user, name: "Bill", email: "bill@murray.com").handle.should == "Bill"
      end
    end

    describe "#remove_credits" do 
      it "should remove points from the users point total" do 
        user = FactoryGirl.create(:user, credits: 100)
        user.remove_credits(50)
        user.credits.should == 50
      end
    end

    describe "#custom_series_ids" do 
      before do 
        @series = FactoryGirl.create(:series)
        @custom_series = FactoryGirl.create(:custom_series, series: @series)
        FactoryGirl.create(:custom_series_license, user: user, custom_series: @custom_series)
      end

      it "should return the ids of custom_series user has joined" do        
        custom_series2 = FactoryGirl.create(:custom_series, series: @series)
        FactoryGirl.create(:custom_series_license, user: user, custom_series: custom_series2)
        ids = user.custom_series_ids(@series)
        expect(ids).to include @custom_series.id
        expect(ids).to include custom_series2.id
      end

      it "should not return the ids of custom_series for other series" do
        series2 = FactoryGirl.create(:series)
        user.series_licenses.create(series: series2)
        custom_series2 = FactoryGirl.create(:custom_series, series: series2)
        FactoryGirl.create(:custom_series_license, user: user, custom_series: custom_series2)
        expect(user.custom_series_ids(@series)).to eq [@custom_series.id]
        expect(user.custom_series_ids(series2)).to eq [custom_series2.id]
      end
    end

    describe "#participant_in_round?" do
      it "should return true if a user has made guesses for a round" do
        user.rider_positions.create(rider: @rider, round: @round, position: 1)
        expect(user.participant_in_round? @round).to be true
      end

      it "should return true if a user has made guesses for a round" do
        expect(user.participant_in_round? @round).to be false
      end
    end

    describe "#after_sign_in_path" do
      it "should return the user's profile path if the user has no pending invitations" do
        expect(user.after_sign_in_path).to eq "/users/#{user.id}"
      end

      it "should return the most recent custom series invitation path if the user has a pending invitation" do
        old_invitation = FactoryGirl.create :custom_series_invitation,
                                            recipient_email: user.email
        invitation = FactoryGirl.create :custom_series_invitation,
                                        recipient_email: user.email
        expect(user.after_sign_in_path).to eq "/custom_series/#{invitation.custom_series_id}?token=#{invitation.token}"
      end
    end

  end
end
