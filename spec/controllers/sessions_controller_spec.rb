require 'spec_helper'

describe SessionsController do
  describe "Get new" do
    it "redirects to home path for current user" do
      user = Fabricate(:user)
      session[:user_id] = user.id 
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "Post create" do
    it "sets user with user email" do
      user = Fabricate(:user)
      expect(User.find_by(email: user.email)).to eq(user)
    end
    it "redirects to home path when user authenticate" do 
      user = Fabricate(:user)
      post :create, user: {email: user.email, password: user.password}
      expect(assigns(session[:user_id])).to eq(user.id)
    end
    it "renders new template if unauthenticate"
  end
end