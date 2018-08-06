require 'spec_helper'

describe CustomSeriesInvitation do
  context "associations" do
    it 'should belong to a sender(user)' do
      CustomSeriesInvitation.reflect_on_association(:sender).should_not be_nil
      CustomSeriesInvitation.reflect_on_association(:sender).macro.should eql(:belongs_to)
    end

    it 'should belong to a custom series' do
      CustomSeriesInvitation.reflect_on_association(:custom_series).should_not be_nil
      CustomSeriesInvitation.reflect_on_association(:custom_series).macro.should eql(:belongs_to)
    end 
  end

  context "validations" do
    it "should require a user" do
      FactoryGirl.build(:custom_series_invitation, sender: nil).should_not be_valid
    end

    it "should require a custom_series" do
      FactoryGirl.build(:custom_series_invitation, custom_series: nil).should_not be_valid
    end

    it "should require a recipient email" do
      FactoryGirl.build(:custom_series_invitation, recipient_email: nil).should_not be_valid
    end

    it "should require a recipient email in valid format" do
      FactoryGirl.build(:custom_series_invitation, recipient_email: "bad@format").should_not be_valid
    end

    it "should be valid with valid data" do
      FactoryGirl.build(:custom_series_invitation).should be_valid
    end
  end

  context "#methods" do 
    describe "generate_token" do 
      it "should generate a token on create" do 
        invite = FactoryGirl.create(:custom_series_invitation, token: nil)
        expect(invite.generate_token).to_not be_nil
      end
    end
  end

  context ".class_methods" do 
    describe "for_token_and_email" do 
      let(:invite) { FactoryGirl.create :custom_series_invitation, token: nil }

      it "should locate a matching token and email address" do 
        non_matching_invite = FactoryGirl.create(:custom_series_invitation, token: nil)
        expect(CustomSeriesInvitation.for_token_and_email invite.token, invite.recipient_email).to eq invite
      end

      it "should throw a special exception if the email address doesn't match" do
        expect { CustomSeriesInvitation.for_token_and_email invite.token, "bad@example.org" }.to raise_error(CustomSeriesInvitation::EmailMismatchError)
      end

      it "should not throw an exception if the email addresses differ only in case" do
        expect(CustomSeriesInvitation.for_token_and_email invite.token, "New@user.com").to eq invite
      end

      it "should throw a standard exception if the token doesn't exist" do
        expect { CustomSeriesInvitation.for_token_and_email "abcdefg", "bad@example.org" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
