require 'spec_helper'

describe BonusType do
  context "validations" do
    it "should require a name" do
      FactoryGirl.build(:bonus_type, name: nil).should_not be_valid
    end

    it "should require a unique name" do
      FactoryGirl.create(:bonus_type, name: "HeatWinner")
      FactoryGirl.build(:bonus_type, name: "HeatWinner").should_not be_valid
    end

    it "should be valid with a name" do
      FactoryGirl.build(:bonus_type).should be_valid
    end
  end

  describe ".ordered" do
    it "uses the custom specified order" do
      ["HeatWinner", "HoleShot", "PolePosition"].each{|b_type| FactoryGirl.create(:bonus_type, name: b_type) }
      expect(BonusType.ordered.first.name).to eq("PolePosition")
    end
  end

end
