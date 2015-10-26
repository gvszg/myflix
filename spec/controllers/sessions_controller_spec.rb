require 'spec_helper'

describe SessionsController do
  describe "Get new" do
    it "renders new template for unauthenticate user" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to home path for authenticate user" do
      session[:user_id] = Fabricate(:user).id 
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "Post create" do
    let(:user) { Fabricate(:user) }

    context "with valid credentials" do
      before do
        post :create, email: user.email, password: user.password        
      end 

      it "puts the signed in user in the session" do        
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end

      it "sets the notice message" do    
        expect(flash[:warning]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      before do
        post :create, email: user.email, password: user.password + 'else'
      end

      it "does not put the signed in user in the session" do        
        expect(session[:user_id]).to be_nil
      end

      it "renders the new template" do
        expect(response).to render_template :new 
      end

      it "sets error message" do
        expect(flash[:danger]).not_to be_blank 
      end
    end
  end

  describe "Get destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "clears the session for the user" do 
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path 
    end

    it "sets notice message" do
      expect(flash[:warning]).not_to be_blank  
    end
  end
end