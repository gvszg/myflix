require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "with valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true) }

      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      after { ActionMailer::Base.deliveries.clear }

      it "creates user " do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', password: 'password', username: 'Joe Smith' }, invitation_token: invitation.token
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(alice)).to be_truthy
      end


      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', password: 'password', username: 'Joe Smith' }, invitation_token: invitation.token
        joe = User.find_by(email: 'joe@example.com')
        expect(alice.follows?(joe)).to be_truthy
      end


      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', password: 'password', username: 'Joe Smith' }, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: 'joe@example.com', password: 'password', username: 'Joe Smith' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: 'joe@example.com', password: 'password', username: 'Joe Smith' }
        expect(ActionMailer::Base.deliveries.last.body).to include('Joe Smith')
      end
    end # end context

    context "with valid personal info and declined card" do      
      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined.") }

      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it "does not create a new user" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1223'
        expect(User.count).to eq(0)
      end            
    end # end context

    context "with invalid personal info" do
      before do
        post :create, user: { username: "Jam", password: "istrue" }
      end

      it "does not create user" do        
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do        
        expect(response).to render_template :new
      end

      it "deos not send out email to the user with invalid inputs" do
        post :create, user: { email: 'joe@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets @user" do      
        expect(assigns(:user)).to be_instance_of(User) 
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)        
      end
    end # end context
  end
end