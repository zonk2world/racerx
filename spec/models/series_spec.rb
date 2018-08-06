require 'spec_helper'

describe Series do
  context "associations" do
    it 'should have many race_classes' do
      Series.reflect_on_association(:race_classes).should_not be_nil
      Series.reflect_on_association(:race_classes).macro.should eql(:has_many)
    end

    it 'should have many series licenses' do
      Series.reflect_on_association(:series_licenses).should_not be_nil
      Series.reflect_on_association(:series_licenses).macro.should eql(:has_many)
    end

    it 'should have many rounds' do
      Series.reflect_on_association(:rounds).should_not be_nil
      Series.reflect_on_association(:rounds).macro.should eql(:has_many)
    end

    it 'should have many users' do
      Series.reflect_on_association(:users).should_not be_nil
      Series.reflect_on_association(:users).macro.should eql(:has_many)
    end
  end

  context "validations" do
    it "should require a cost" do
      FactoryGirl.build(:series, cost: nil).should_not be_valid
    end

    it "should require a number for cost" do
      FactoryGirl.build(:series, cost: "abc").should_not be_valid
    end

    it "should be valid with a valid cost" do
      FactoryGirl.build(:series, cost: 100).should be_valid
    end
  end

end
