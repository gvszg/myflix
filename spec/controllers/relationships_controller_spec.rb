require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      joe = Fabricate(:user)
      set_current_user(joe)
      emma = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: joe, leader: emma)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to people page" do
      joe = Fabricate(:user)
      set_current_user(joe)
      emma = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: joe, leader: emma)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if current user is the follower" do
      joe = Fabricate(:user)
      set_current_user(joe)
      emma = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: joe, leader: emma)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if current user is not the follower" do
      joe = Fabricate(:user)
      set_current_user(joe)
      emma = Fabricate(:user)
      alice = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: emma)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end
end