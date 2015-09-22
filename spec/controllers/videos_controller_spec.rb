require 'spec_helper'

describe VideosController do
  describe "GET show" do 
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "set @review for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      assigns(:reviews).should =~ [review1, review2]
      #expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "redirects the user to the sign in page for unauthenticated users" do      video = Fabricate(:video)
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do
    it "sets @results for authenticated users" do
      Video.reindex
      Video.searchkick_index.refresh
      session[:user_id] = Fabricate(:user).id
      futurama = Video.create(title: 'Futurama', description: 'asdf')
      futurama.save
      get :search, search_term: 'Futurama'
      expect(assigns(:results).first).to eq(futurama)
    end
    it "redirects to sign in page for the unauthenticated users" do
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, search_term: 'rama'
      expect(response).to redirect_to sign_in_path
    end
  end
end