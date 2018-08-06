require 'spec_helper'

describe SeriesLicense do
  context "associations" do
    it 'should belong to a user' do
      SeriesLicense.reflect_on_association(:user).should_not be_nil
      SeriesLicense.reflect_on_association(:user).macro.should eql(:belongs_to)
    end

    it 'should belong to a Licensable' do
      SeriesLicense.reflect_on_association(:series).should_not be_nil
      SeriesLicense.reflect_on_association(:series).macro.should eql(:belongs_to)
    end
  end

  context "validations" do
    it "should require a user" do
      FactoryGirl.build(:series_license, user: nil).should_not be_valid
    end

    it "should require a series" do
      FactoryGirl.build(:series_license, series: nil).should_not be_valid
    end

    it "should be valid with valid data" do
      FactoryGirl.build(:series_license).should be_valid
    end

    it "should not allow the same user to be added more than once" do
      user = FactoryGirl.create(:user)
      series = FactoryGirl.create(:series)
      FactoryGirl.create(:series_license, user: user, series: series)
      FactoryGirl.build(:series_license, user: user, series: series).should_not be_valid
    end
  end
end
