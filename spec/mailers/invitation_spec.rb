require "spec_helper"

describe Invitation do
  let(:user) { FactoryGirl.create(:user, email: "bill@cosby.com") }
  let(:invitation) { FactoryGirl.create(:custom_series_invitation, sender: user, recipient_email: "hulk@hogan.com") }
  let(:mail) { Invitation.send_private_series_invite(invitation) }
  
  describe "invitation" do
    it "should send the user_message to the pitcrew email" do
      mail.subject.should match("Join the MotoDynasty private series Custom Series")
      mail.to.should eq(['hulk@hogan.com'])
      mail.from.should eq(['bill@cosby.com'])
      mail.body.encoded.should match("has invited you to participate in a private series for MotoDynasty")
    end
  end
end
