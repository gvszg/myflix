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

    it "normalizes the remaining queue items" do
      dani = Fabricate(:user)
      session[:user_id] = dani.id
      queue_item1 = Fabricate(:queue_item, user: dani, position: 1)
      queue_item2 = Fabricate(:queue_item, user: dani, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
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

  describe "Post update_queue" do
    context "with valid inputs" do
      it "redirects to my queue items page" do
        joe = Fabricate(:user)
        session[:user_id] = joe.id
        queue_item1 = Fabricate(:queue_item, user: joe, position: 1)
        queue_item2 = Fabricate(:queue_item, user: joe, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reoders the queue items" do
        joe = Fabricate(:user)
        session[:user_id] = joe.id
        queue_item1 = Fabricate(:queue_item, user: joe, position: 1)
        queue_item2 = Fabricate(:queue_item, user: joe, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(joe.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalize the queue items numbers" do
        joe = Fabricate(:user)
        session[:user_id] = joe.id
        queue_item1 = Fabricate(:queue_item, user: joe, position: 1)
        queue_item2 = Fabricate(:queue_item, user: joe, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(joe.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      it "redirects to my queue page" do
        joe = Fabricate(:user)
        session[:user_id] = joe.id
        queue_item1 = Fabricate(:queue_item, user: joe, position: 1)
        queue_item2 = Fabricate(:queue_item, user: joe, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path 
      end

      it "sets the flash error message" do
        joe = Fabricate(:user)
        session[:user_id] = joe.id
        queue_item1 = Fabricate(:queue_item, user: joe, position: 1)
        queue_item2 = Fabricate(:queue_item, user: joe, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue items" do
        joe = Fabricate(:user)
        session[:user_id] = joe.id
        queue_item1 = Fabricate(:queue_item, user: joe, position: 1)
        queue_item2 = Fabricate(:queue_item, user: joe, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to sign in page" do
        post :update_queue, queue_items: [{id: 2, position: 3}, {id: 4, position: 2}]
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with queue items that do not belong to current user" do
      it "does not change queue items" do
        joe = Fabricate(:user)
        session[:user_id] = joe.id
        sam = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: sam, position: 1)
        queue_item2 = Fabricate(:queue_item, user: joe, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 5}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end