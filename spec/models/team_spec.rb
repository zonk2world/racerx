require 'spec_helper'

describe Team do
  context "associations" do
    it 'should have many riders' do
      Team.reflect_on_association(:riders).should_not be_nil
      Team.reflect_on_association(:riders).macro.should eql(:has_many)
    end
  end
end
