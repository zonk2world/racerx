require 'spec_helper'

describe RoundBonusWinner do
  context "associations" do
    it 'should belong to a rider' do
      RoundBonusWinner.reflect_on_association(:rider).should_not be_nil
      RoundBonusWinner.reflect_on_association(:rider).macro.should eql(:belongs_to)
    end

    it 'should belong to a round' do
      RoundBonusWinner.reflect_on_association(:round).should_not be_nil
      RoundBonusWinner.reflect_on_association(:round).macro.should eql(:belongs_to)
    end

    it 'should belong to a bonus type' do
      RoundBonusWinner.reflect_on_association(:bonus_type).should_not be_nil
      RoundBonusWinner.reflect_on_association(:bonus_type).macro.should eql(:belongs_to)
    end
  end

  context "validations" do
    it "should require a rider" do
      FactoryGirl.build(:round_bonus_winner, rider: nil).should_not be_valid
    end

    it "should require a round" do
      FactoryGirl.build(:round_bonus_winner, round: nil).should_not be_valid
    end

    it "should require a bonus_type" do
      FactoryGirl.build(:round_bonus_winner, bonus_type: nil).should_not be_valid
    end

    it "should be valid with valid data" do
      FactoryGirl.build(:round_bonus_winner).should be_valid
    end
  end
end
