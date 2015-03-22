require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do

    after { ActionMailer::Base.deliveries.clear }

    context "valid personal info and valid card" do
      let(:charge) {double(:charge, successful?: true)}

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        kevin = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: kevin, recipient_email: 'ellie@example.com')
        UserSignup.new(Fabricate.build(:user, email: "ellie@example.com", password: "password", full_name: "Ellie Lai")).sign_up("some_stripe_token", invitation.token)
        ellie = User.where(email: 'ellie@example.com').first
        expect(ellie.follows?(kevin)).to be_truthy
      end

      it "make the inviter follow the user" do
        kevin = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: kevin, recipient_email: 'ellie@example.com')
        UserSignup.new(Fabricate.build(:user, email: "ellie@example.com", password: "password", full_name: "Ellie Lai")).sign_up("some_stripe_token", invitation.token)
        ellie = User.where(email: 'ellie@example.com').first
        expect(kevin.follows?(ellie)).to be_truthy
      end

      it "expired the invitation upon acceptance" do
        kevin = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: kevin, recipient_email: 'ellie@example.com')
        UserSignup.new(Fabricate.build(:user, email: "ellie@example.com", password: "password", full_name: "Ellie Lai")).sign_up("some_stripe_token", invitation.token)
        ellie = User.where(email: 'ellie@example.com').first
        expect(Invitation.first.token).to be_nil
      end

      it "sends out emails to the user with valid input" do
        UserSignup.new(Fabricate.build(:user, email: "ellie@example.com")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['ellie@example.com'])
      end

      it "sends out emails containing the user's name with valid input" do
        UserSignup.new(Fabricate.build(:user, email: "ellie@example.com", full_name: "Ellie Lai")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('Ellie Lai')
      end
    end

    context "valid personal info and declined card" do
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up('123123', nil)
        expect(User.count).to eq(0)
      end 
    end

    context "invalid personal info" do
      
      it "does not create the user" do
        UserSignup.new(User.new(email: "kevin@example.com")).sign_up('123123', nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        UserSignup.new(User.new(email: "kevin@example.com")).sign_up('123123', nil)
      end

      it "does not send email with invalid input" do
        UserSignup.new(User.new(email: "kevin@example.com")).sign_up('123123', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end