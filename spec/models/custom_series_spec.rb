require 'spec_helper'

describe CustomSeries do
  context "associations" do
    it 'should belong to a series' do
      CustomSeries.reflect_on_association(:series).should_not be_nil
      CustomSeries.reflect_on_association(:series).macro.should eql(:belongs_to)
    end

    it 'should have many custom series licenses' do
      CustomSeries.reflect_on_association(:custom_series_licenses).should_not be_nil
      CustomSeries.reflect_on_association(:custom_series_licenses).macro.should eql(:has_many)
    end

    it 'should have many users' do
      CustomSeries.reflect_on_association(:users).should_not be_nil
      CustomSeries.reflect_on_association(:users).macro.should eql(:has_many)
    end
  end

  context "validations" do
    it "should require a name" do
      FactoryGirl.build(:custom_series, name: nil).should_not be_valid
    end

    it "should require a series" do
      FactoryGirl.build(:custom_series, series: nil).should_not be_valid
    end

    it "should be valid with valid data" do
      FactoryGirl.build(:custom_series).should be_valid
    end
  end

  describe "#includes_user?" do
    let(:joined_user_license) { FactoryGirl.create :custom_series_license }
    let(:joined_user) { joined_user_license.user }
    let(:random_user) { FactoryGirl.build :user }
    subject(:custom_series) { joined_user_license.custom_series }

    it "should indicate that a user has joined a custom series" do
      expect(custom_series.includes_user? joined_user).to be true
    end

    it "should indicate that non-invited users have not joined" do
      expect(custom_series.includes_user? random_user).to be false
    end
  end
end
