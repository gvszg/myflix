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

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 5 }
    end

    it "redirects to people page" do
      joe = Fabricate(:user)
      set_current_user(joe)
      emma = Fabricate(:user)
      post :create, leader_id: emma.id
      expect(response).to redirect_to people_path
    end

    it "creates a relationship that the current user follows the leader" do
      joe = Fabricate(:user)
      set_current_user(joe)
      emma = Fabricate(:user)
      post :create, leader_id: emma.id
      expect(joe.following_relationships.first.leader).to eq(emma)
    end

    it "does not create a relationship if the current user already follows the leader" do
      joe = Fabricate(:user)
      set_current_user(joe)
      emma = Fabricate(:user)
      Fabricate(:relationship, leader: emma, follower: joe)
      post :create, leader_id: emma.id
      expect(Relationship.count).to eq(1)
    end

    it "does not allow one to follow themselves" do
      joe = Fabricate(:user)
      set_current_user(joe)
      post :create, leader_id: joe.id
      expect(Relationship.count).to eq(0)
    end
  end
end
