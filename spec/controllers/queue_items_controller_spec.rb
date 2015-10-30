require 'spec_helper'

describe QueueItemsController do 
  describe "Get index" do
    it "sets @queue_items to queue items of logged in user" do
      dani = Fabricate(:user)
      session[:user_id] = dani.id
      queue_item1 = Fabricate(:queue_item, user: dani)
      queue_item2 = Fabricate(:queue_item, user: dani) 
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to sign page for unauthenticated user" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "Post create" do
    it "redirects to my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue_item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue_item that is associated with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue_item that is associated with signed in user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user)
    end

    it "puts the video as the last one in the queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      film_1 = Fabricate(:video)
      Fabricate(:queue_item, video: film_1, user: user)
      film_2 = Fabricate(:video)
      post :create, video_id: film_2.id
      film_2_queue_item = QueueItem.find_by(video_id: film_2.id, user_id: user.id)
      expect(film_2_queue_item.position).to eq(2)
    end

    it "does not add video in queue if the video already in the queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      film_1 = Fabricate(:video)
      Fabricate(:queue_item, video: film_1, user: user)
      post :create, video_id: film_1.id
      expect(user.queue_items.count).to eq(1)
    end

    it "redirects to sign in page for unauthenticated users" do
      post :create, video_id: 9
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "Delete destroy" do
    it "redirects to my queue page" do
      dani = Fabricate(:user)
      session[:user_id] = dani.id
      queue_item = Fabricate(:queue_item, user: dani)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      dani = Fabricate(:user)
      session[:user_id] = dani.id
      queue_item = Fabricate(:queue_item, user: dani)
      delete :destroy, id: queue_item.id
      expect(dani.queue_items.count).to eq(0)
    end

    it "does not delete the queue item if the queue item isn't in current user's queue" do
      dani = Fabricate(:user)
      vinson = Fabricate(:user)
      session[:user_id] = dani.id
      queue_item = Fabricate(:queue_item, user: vinson)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "redirects to sign in page for unauthenticated users" do
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to sign_in_path
    end
  end
end