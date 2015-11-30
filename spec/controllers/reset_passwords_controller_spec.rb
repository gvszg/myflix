require 'spec_helper'

describe ResetPasswordsController do
  describe "GET show" do
    it "renders the show template if the token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to invalid_token_path
    end
  end
end