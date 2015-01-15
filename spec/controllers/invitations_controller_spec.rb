require "spec_helper"

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do 
      let(:action) { post :create }
    end

    context "with valid input" do
      it "redirects to the invitation new page" do
        set_current_user
        post :create, invitation: { recipient_name: "Kevin Chang", recipient_email: "kevin@example.com", message: "Hey join Myflix!" }
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Kevin Chang", recipient_email: "kevin@example.com", message: "Hey join Myflix!" }
        expect(Invitation.count).to eq(1)
      end

      it "send eamil to teh recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Kevin Chang", recipient_email: "kevin@example.com", message: "Hey join Myflix!" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['kevin@example.com'])
      end
    end

    context "with invalid input"
  end
end