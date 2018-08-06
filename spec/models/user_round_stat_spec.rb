require 'spec_helper'

describe UserRoundStat do
  context "associations" do
    it 'should belong to a user' do
      UserRoundStat.reflect_on_association(:user).should_not be_nil
      UserRoundStat.reflect_on_association(:user).macro.should eql(:belongs_to)
    end

    it 'should belong to a round' do
      UserRoundStat.reflect_on_association(:round).should_not be_nil
      UserRoundStat.reflect_on_association(:round).macro.should eql(:belongs_to)
    end
  end

  context "validations" do
    it "should require a user" do
      FactoryGirl.build(:user_round_stat, user: nil).should_not be_valid
    end

    it "should require a round" do
      FactoryGirl.build(:user_round_stat, round: nil).should_not be_valid
    end

    it "should be valid with valid data" do
      FactoryGirl.build(:user_round_stat).should be_valid
    end
  end
end
