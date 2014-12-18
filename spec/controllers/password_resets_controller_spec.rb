require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      kevin = Fabricate(:user)
      kevin.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @token" do
      kevin = Fabricate(:user)
      kevin.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      
      it "redirects to the sign in page" do
        kevin = Fabricate(:user, password: 'old_password')
        kevin.update_column(:token, '12345')
        post :create, password: 'new_password', token: '12345'
        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password" do
        kevin = Fabricate(:user, password: 'old_password')
        kevin.update_column(:token, '12345')
        post :create, password: 'new_password', token: '12345'
        expect(kevin.reload.authenticate('new_password')).to be_truthy
      end
      it "sets the flash success message" do
        kevin = Fabricate(:user, password: 'old_password')
        kevin.update_column(:token, '12345')
        post :create, password: 'new_password', token: '12345'
        expect(flash[:success]).to be_present
      end
      it "regenerate the user's token" do
        kevin = Fabricate(:user, password: 'old_password')
        kevin.update_column(:token, '12345')
        post :create, password: 'new_password', token: '12345'
        expect(kevin.reload.token).not_to eq('12345')
      end
    end

    context "with invalid token" do
      it "redirects to the expired token path" do
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end