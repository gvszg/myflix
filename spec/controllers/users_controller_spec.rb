require 'spec_helper'

describe UsersController do
  describe "Get new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end # Get new end

  describe "Post create" do
    context "successful user sign up" do
      it "redirects to sign_in_path" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)        
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end          
    end # end context

    context "failed user signup" do
      it "render the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "Some error")  
        UserSignup.any_instance.should_receive(:sign_up).and_return(result) 
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1223'
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        result = double(:sign_up_result, successful?: false, error_message: "Some error")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1223'
        expect(flash[:danger]).to eq("Some error")
      end
    end
  end # Post create end
        
  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "sets @user" do
      set_current_user
      joe = Fabricate(:user)
      get :show, id: joe.id
      expect(assigns(:user)).to eq(joe)
    end
  end # Get show end

  describe "GET new_with_invitation_token" do
    it "renders the new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's name" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: '123asd'
      expect(response).to redirect_to invalid_token_path
    end
  end # GET new_with_invitation_token end
end