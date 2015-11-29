require 'spec_helper'

describe UsersController do
  describe "Get new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "Post create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates user " do
        expect(User.count).to eq(1)
      end

      it "redirects to sign_in_path" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalid input" do
      before do
        post :create, user: { username: "Jam", password: "istrue" }
      end

      it "does not create user" do        
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do        
        expect(response).to render_template :new
      end

      it "sets @user" do      
        expect(assigns(:user)).to be_instance_of(User) 
      end
    end

    context "sending emails" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: 'joe@example.com', password: 'password', username: 'Joe Smith' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: 'joe@example.com', password: 'password', username: 'Joe Smith' }
        expect(ActionMailer::Base.deliveries.last.body).to include('Joe Smith')
      end

      it "deos not send out email to the user with invalid inputs" do
        post :create, user: { email: 'joe@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

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
  end
end
