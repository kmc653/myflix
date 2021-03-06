require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC") }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

  describe "#queued_video" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_truthy
    end
    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should be_falsey
    end
  end

  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).to be_truthy
    end

    it "returns false if the user does not have a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: bob)
      expect(alice.follows?(bob)).to be_falsey
    end
  end

  describe "#follow" do
    it "follows another user" do
      kevin = Fabricate(:user)
      bob = Fabricate(:user)
      kevin.follow(bob)
      expect(kevin.follows?(bob)).to be_truthy
    end

    it "does not follow oneself" do
      kevin = Fabricate(:user)
      kevin.follow(kevin)
      expect(kevin.follows?(kevin)).to be_falsey
    end
  end

  describe "deactivate!" do
    it "deactivates an active user" do
      kevin = Fabricate(:user, active: true)
      kevin.deactivate!
      expect(kevin).not_to be_active
    end
  end
end