require 'spec_helper'

describe VideosController do 
  describe "Get show" do
    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
      end

      it "sets the @video" do
        video = Fabricate(:video)
        get :show, :id => video.id
        expect(assigns(:video)).to eq(video)
      end

      it "renders the show template"
    end
  end
end