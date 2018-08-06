require 'spec_helper'

describe RiderPosition do
  context "associations" do
    it 'should belong to a rider' do
      RiderPosition.reflect_on_association(:rider).should_not be_nil
      RiderPosition.reflect_on_association(:rider).macro.should eql(:belongs_to)
    end

    it 'should belong to a round' do
      RiderPosition.reflect_on_association(:round).should_not be_nil
      RiderPosition.reflect_on_association(:round).macro.should eql(:belongs_to)
    end

    it 'should belong to a round' do
      RiderPosition.reflect_on_association(:user).should_not be_nil
      RiderPosition.reflect_on_association(:user).macro.should eql(:belongs_to)
    end
  end

  context "validations" do
    it "should require a round" do
      FactoryGirl.build(:rider_position, round: nil).should_not be_valid
    end

    it "should require a round" do
      FactoryGirl.build(:rider_position, round: nil).should_not be_valid
    end

    it "should be valid with valid data" do
      FactoryGirl.build(:rider_position).should be_valid
    end
  end
end
