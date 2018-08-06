require 'spec_helper'

describe Rider do
  context "associations" do
    it 'should have many round riders' do
      expect(Rider.reflect_on_association(:round_riders)).to_not be_nil
      expect(Rider.reflect_on_association(:round_riders).macro).to eql(:has_many)
    end

    it 'should have many round' do
      expect(Rider.reflect_on_association(:rounds)).to_not be_nil
      expect(Rider.reflect_on_association(:rounds).macro).to eql(:has_many)
    end

    it 'should belong to a team' do
      expect(Rider.reflect_on_association(:team)).to_not be_nil
      expect(Rider.reflect_on_association(:team).macro).to eql(:belongs_to)
    end

    it 'should have many points' do
      expect(Rider.reflect_on_association(:points)).to_not be_nil
      expect(Rider.reflect_on_association(:points).macro).to eql(:has_many)
    end

    it 'should delete round riders on delete' do
      round = FactoryGirl.create(:round)
      rider = FactoryGirl.create(:rider)
      round_rider = FactoryGirl.create(:round_rider, round: round, rider: rider)
      expect(round.round_riders.count).to eq 1
      rider.destroy
      expect(round.round_riders.count).to eq 0
    end

    it 'should delete points on delete' do
      rider = FactoryGirl.create(:rider)
      FactoryGirl.create(:point, pointable_id: rider.id, pointable_type: "Rider")
      expect(Point.count).to eq 1
      rider.destroy
      expect(Point.count).to eq 0
    end
  end

  context "validations" do
    it 'should have a name' do
      expect(FactoryGirl.build(:rider, name: nil)).to_not be_valid
    end

    it 'should have a unique name' do
      FactoryGirl.create(:rider, name: "Dakota Tedder")
      expect(FactoryGirl.build(:rider, name: "Dakota Tedder")).to_not be_valid
    end

    it 'should have a race number' do
      expect(FactoryGirl.build(:rider, race_number: nil)).to_not be_valid
    end

    it 'should be valid with a name and race_number' do
      expect(FactoryGirl.build(:rider)).to be_valid
    end
  end

  describe "#to_s" do
    let(:rider) { FactoryGirl.create(:rider, name: "Ryan Villopoto", race_number: 1)}

    it "should return the race number and name if they exist" do 
      expect(rider.to_s).to eq "1 Ryan Villopoto"
    end
  end
end
