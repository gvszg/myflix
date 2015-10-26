require 'spec_helper'

describe VideosController do 
  describe "Get show" do
    it "sets the @video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
  
    it "redirect to sign path for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "Get search" do
    it "sets results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      black = Fabricate(:video, title: "Black and White")
      get :search, search_term: "hite"
      expect(assigns(:results)).to eq([black])
    end
    it "redirects to sign in path for unauthenticated users" do
      black = Fabricate(:video, title: "Black and White")
      get :search, search_term: "hite"
      expect(response).to redirect_to sign_in_path
    end
  end
end