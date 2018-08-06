require 'spec_helper'

describe CustomSeriesLicense do
  context "associations" do
    it 'should belong to a custom series' do
      CustomSeriesLicense.reflect_on_association(:custom_series).should_not be_nil
      CustomSeriesLicense.reflect_on_association(:custom_series).macro.should eql(:belongs_to)
    end

    it 'should belong to a user' do
      CustomSeriesLicense.reflect_on_association(:user).should_not be_nil
      CustomSeriesLicense.reflect_on_association(:user).macro.should eql(:belongs_to)
    end 
  end

  context "validations" do
    it "should require a user" do
      FactoryGirl.build(:custom_series_license, user: nil).should_not be_valid
    end

    it "should require a custom_series" do
      FactoryGirl.build(:custom_series_license, custom_series: nil).should_not be_valid
    end

    it "should be valid with valid data" do
      FactoryGirl.build(:custom_series_license).should be_valid
    end

    it "should not allow the same user to be added more than once" do
      user = FactoryGirl.create(:user)
      custom_series = FactoryGirl.create(:custom_series)
      FactoryGirl.create(:custom_series_license, user: user, custom_series: custom_series)
      FactoryGirl.build(:custom_series_license, user: user, custom_series: custom_series).should_not be_valid
    end
  end
end
