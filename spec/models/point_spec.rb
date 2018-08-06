require 'spec_helper'

describe Point do
  context "associations" do
    it 'should belong to a pointable object' do
      Point.reflect_on_association(:pointable).should_not be_nil
      Point.reflect_on_association(:pointable).macro.should eql(:belongs_to)
    end
  end
end
