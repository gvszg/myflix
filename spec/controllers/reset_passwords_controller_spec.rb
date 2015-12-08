require 'spec_helper'

describe ResetPasswordsController do
  describe "GET show" do
    it "renders the show template if the token is valid" do
      alice = Fabricate(:user, token: '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @token" do
      alice = Fabricate(:user, token: '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      let!(:alice) { Fabricate(:user, password: 'old_password', token: '12345') }

      # before { alice.update_column(:token, '12345') }

      it "redirects to the sign in page" do              
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password" do      
        post :create, token: '12345', password: 'new_password'
        expect(alice.reload.authenticate('new_password')).to be_truthy  
      end

      it "deletes the user's token after update password" do
        post :create, token: '12345', password: 'new_password'
        expect(alice.reload.token).to be_blank
      end

      it "sets the success message" do      
        post :create, token: '12345', password: 'new_password'
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid token" do
      it "redirects to the invalid token page" do
        post :create, token: '12345', password: 'some password'
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end