require 'spec_helper'
require "cancan/matchers"

describe "User" do
  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:user){ FactoryGirl.create(:user) }

    context "Guest user" do 
      it{ should_not be_able_to(:manage, User.new) }
    end

    context "admin" do
      let(:user){ FactoryGirl.create(:admin) }

      it{ should be_able_to(:manage, :all) }
    end

    context "Registered user" do
      let(:user2){ FactoryGirl.create(:user) }

      it{ should be_able_to(:manage, user) }
      it{ should_not be_able_to(:manage, user2) }

      context "who owns a custom series" do
        let(:custom_series) { FactoryGirl.create :custom_series, owner: user }
        let(:owner_license) { custom_series.custom_series_licenses.create user: user }
        let(:user2_license) { custom_series.custom_series_licenses.create user: user2 }
        let(:invitation) { custom_series.custom_series_invitations.create recipient_email: 'test@example.com',
                                                                          sender: user }

        let(:another_custom_series) { FactoryGirl.create :custom_series }
        let(:another_custom_series_license) { another_custom_series.custom_series_licenses.create user: user2 }
        let(:another_invitation) { custom_series.custom_series_invitations.create recipient_email: 'text@example.com',
                                                                                  sender: user2 }

        it "should be able to destroy their custom series' licenses" do
          expect(subject).to be_able_to(:destroy, user2_license)
        end

        it "should not be able to destroy their own license" do
          expect(subject).to_not be_able_to(:destroy, owner_license)
        end

        it "should not be able to destroy other custom series' licenses" do
          expect(subject).to_not be_able_to(:destroy, another_custom_series_license)
        end

        it "should be able to destroy their custom series invitations" do
          expect(subject).to be_able_to(:destroy, invitation)
        end

        it "should not be able to destroy other custom series' invitations" do
          expect(subject).to_not be_able_to(:destroy, another_invitation)
        end

        context "invited to a custom series" do
          let(:custom_series) { FactoryGirl.create :custom_series, owner: user2 }
          let(:invitation) { custom_series.custom_series_invitations.create recipient_email: user.email,
                                                                            sender: user2 }

          it "should be able to destroy their invitation" do
            expect(subject).to be_able_to(:destroy, invitation)
          end
        end
      end
    end
  end
end
