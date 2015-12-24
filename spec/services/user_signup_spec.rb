require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "with valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true) }

      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      after { ActionMailer::Base.deliveries.clear }

      it "creates user " do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', username: 'Joe Smith')).sign_up("stripe_token", invitation.token)
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(alice)).to be_truthy
      end


      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', username: 'Joe Smith')).sign_up("stripe_token", invitation.token)
        joe = User.find_by(email: 'joe@example.com')
        expect(alice.follows?(joe)).to be_truthy
      end


      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', username: 'Joe Smith')).sign_up("stripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end

      it "sends out email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com')).sign_up("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', username: 'Joe Smith')).sign_up("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('Joe Smith')
      end
    end # end context

    context "with valid personal info and declined card" do      
      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined.") }

      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it "does not create a new user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.count).to eq(0)
      end            
    end # end context

    context "with invalid personal info" do
      before do
        UserSignup.new(User.new(username: "Joe", email: 'joe@example.com'))
      end

      it "does not create user" do
        expect(User.count).to eq(0)
      end

      it "deos not send out email to the user with invalid inputs" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    
      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end
    end # end context
  end
end