require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers
  before do
    @user = FactoryGirl.create(:user) 
    sign_in @user
  end

  let(:valid_attributes) { { name: "Egon Spengler", email: "egon1@bustinghosts.com",
                             password: "do3rayEgon", password_confirmation: "do3rayEgon" } }

  describe "GET show" do
    it "assigns the requested user as @user" do
      get :show, {id: @user.to_param}
      expect { assigns(:user).to eq(@user) }
      expect { assigns(:current_round).to eq(1) }
    end
  end
end
