require 'spec_helper'

describe Payment do
  context "associations" do
    it 'should belong to a user' do
      Payment.reflect_on_association(:user).should_not be_nil
      Payment.reflect_on_association(:user).macro.should eql(:belongs_to)
    end
  end

  context "validations" do
    it "should require a user" do
      FactoryGirl.build(:payment, user: nil).should_not be_valid
    end

    it "should be valid with valid data" do
      FactoryGirl.build(:payment).should be_valid
    end
  end
end