require 'spec_helper'

describe RoundRider do
  context "associations" do
    it 'should belong to a rider' do
      RoundRider.reflect_on_association(:rider).should_not be_nil
      RoundRider.reflect_on_association(:rider).macro.should eql(:belongs_to)
    end

    it 'should belong to a round' do
      RoundRider.reflect_on_association(:round).should_not be_nil
      RoundRider.reflect_on_association(:round).macro.should eql(:belongs_to)
    end
  end

  context "validations" do
    it "should require a rider" do
      FactoryGirl.build(:round_rider, rider: nil).should_not be_valid
    end

    it "should require a round" do
      FactoryGirl.build(:round_rider, round: nil).should_not be_valid
    end

    it "should be valid with valid data" do
      FactoryGirl.build(:round_rider).should be_valid
    end

    it "riders should not be able to be added to a round more than once" do
      round = FactoryGirl.create(:round)
      rider = FactoryGirl.create(:rider)
      FactoryGirl.create(:round_rider, round: round, rider: rider)
      expect(round.riders.count).to eq 1
      expect(FactoryGirl.build(:round_rider, round: round, rider: rider)).to_not be_valid
    end
  end

  describe "#finished_description" do 
    let(:round_rider) { FactoryGirl.build(:round_rider) }
    let(:finished_round_rider) { FactoryGirl.build(:round_rider, finished_position: 1) }
    it "should should show just the rider name if that rider didn't finish" do 
      expect(round_rider.finished_description).to eq "#{Rider.last.to_s}"
    end

    it "should should show the rider name and finishing position if that rider finished" do 
      finished_round_rider.round.update_attribute(:finished, true)
      expect(finished_round_rider.finished_description).to eq "1st: #{Rider.last.to_s}"
    end
  end
end
