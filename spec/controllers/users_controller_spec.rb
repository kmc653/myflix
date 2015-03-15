require 'spec_helper'

describe UsersController do
  describe "GET new" do
    
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      
      before do
        StripeWrapper::Charge.stub(:create)
        post :create, user: Fabricate.attributes_for(:user)
      end
      
      it "creates the user" do
        expect(User.count).to eq(1)
      end
      
      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end

      it "makes the user follow the inviter" do
        kevin = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: kevin, recipient_email: 'ellie@example.com')
        post :create, user: { email: 'ellie@example.com', password: 'password', full_name: "Ellie Lai" }, invitation_token: invitation.token
        ellie = User.where(email: 'ellie@example.com').first
        expect(ellie.follows?(kevin)).to be_truthy
      end
      it "make the inviter follow the user" do
        kevin = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: kevin, recipient_email: 'ellie@example.com')
        post :create, user: { email: 'ellie@example.com', password: 'password', full_name: "Ellie Lai" }, invitation_token: invitation.token
        ellie = User.where(email: 'ellie@example.com').first
        expect(kevin.follows?(ellie)).to be_truthy
      end
      it "expired the invitation upon acceptance" do
        kevin = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: kevin, recipient_email: 'ellie@example.com')
        post :create, user: { email: 'ellie@example.com', password: 'password', full_name: "Ellie Lai" }, invitation_token: invitation.token
        ellie = User.where(email: 'ellie@example.com').first
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with invalid input" do
      
      before do
        post :create, user: { password: "password", full_name: "Kevin Chang" }
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      
      it "render the :new template" do
        expect(response).to render_template :new
      end
      
      it "set @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "sending emails" do

      before do
        StripeWrapper::Charge.stub(:create)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "sends out emails to the user with valid input" do
        post :create, user: { email: "kevin@example.com", password: "password", full_name: "Kevin Chang" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['kevin@example.com'])
      end

      it "sends out emails containing the user's name with valid input" do
        post :create, user: { email: 'kevin@example.com', password: 'password', full_name: 'Kevin Chang' }
        expect(ActionMailer::Base.deliveries.last.body).to include('Kevin Chang')
      end

      it "does not send email with invalid input" do
        post :create, user: { email: 'kevin@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
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
      get :new_with_invitation_token, token: 'asdfg'
      expect(response).to redirect_to expired_token_path
    end
  end

end