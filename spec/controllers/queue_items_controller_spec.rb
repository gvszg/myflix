require 'spec_helper'

describe QueueItemsController do 
  describe "Get index" do
    it "sets @queue_items to queue items of logged in user" do
      gin = Fabricate(:user)
      session[:user_id] = gin.id
      queue_item1 = Fabricate(:queue_item, user: gin)
      queue_item2 = Fabricate(:queue_item, user: gin) 
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to sign page for unauthenticated user" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end
end