require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    it "sets the @video to a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it "sets flash error message" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      let(:category) { Fabricate(:category, name: 'Move') }
      before { set_current_admin }

      it "redirects to the add new video page" do
        post :create, video: { title: 'Monk', category_id: category.id, description: 'Awesome' }
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a video" do
        post :create, video: { title: 'Monk', category_id: category.id, description: 'Awesome' }
        expect(category.videos.count).to eq(1)
      end
      
      it "sets the flash success message" do
        post :create, video: { title: 'Monk', category_id: category.id, description: 'Awesome' }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      let(:category) { Fabricate(:category, name: 'Move') }
      before { set_current_admin }

      it "does not create a video" do
        post :create, video: { category_id: category.id, description: 'Awesome' }
        expect(category.videos.count).to eq(0)
      end

      it "render the new template" do
        post :create, video: { category_id: category.id, description: 'Awesome' }
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        post :create, video: { category_id: category.id, description: 'Awesome' }
        expect(flash[:danger]).to be_present
      end

      it "sets @video" do
        post :create, video: { category_id: category.id, description: 'Awesome' }
        expect(assigns(:video)).to be_present
      end
    end
  end
end
