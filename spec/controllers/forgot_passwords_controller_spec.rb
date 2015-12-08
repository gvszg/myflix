require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context "with empty input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "shows the error message" do
        post :create, email: ''
        expect(flash[:danger]).to be_present
      end
    end

    context "with existing email" do
      it "redirects to password confirmation page" do
        Fabricate(:user, email: 'joe@example.com')
        post :create, email: 'joe@example.com'
        expect(response).to redirect_to forgot_password_confirm_path
      end

      it "generates new token for the user" do
        joe = Fabricate(:user, email: 'joe@example.com')
        post :create, email: 'joe@example.com'
        expect(joe.reload.token).to be_present
      end

      it "sends out an email to the email address" do
        Fabricate(:user, email: 'joe@example.com')
        post :create, email: 'joe@example.com'
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end
    end

    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: 'foo@bar.com'
        expect(response).to redirect_to forgot_password_path
      end

      it "shows the error message" do
        post :create, email: 'foo@bar.com'
        expect(flash[:danger]).to be_present
      end
    end
  end
end