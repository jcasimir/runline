require 'spec_helper'

describe User do

  before do
    @user1 = FactoryGirl.create(:user, username: "user1")
    @user2 = FactoryGirl.create(:user, username: "user2")
    @user3 = FactoryGirl.create(:user, username: "user3")
    @user4 = FactoryGirl.create(:user, username: "user4")
    @user5 = FactoryGirl.create(:user, username: "user5")
    @user6 = FactoryGirl.create(:user, username: "user6")
    @user7 = FactoryGirl.create(:user, username: "user7")

    Friendship.create(user_id: 1, friend_id: 2, status: "approved")
    Friendship.create(user_id: 1, friend_id: 3, status: "approved")
    Friendship.create(user_id: 7, friend_id: 1, status: "approved")
    Friendship.create(user_id: 4, friend_id: 3, status: "approved")
    Friendship.create(user_id: 2, friend_id: 3, status: "pending")
    Friendship.create(user_id: 6, friend_id: 1, status: "pending")
  end

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should have_many(:friendships) }
  it { should have_many(:friends) }
  it { should have_many(:inverse_friendships) }
  it { should have_many(:inverse_friends) }

  it "should be created with valid attributes" do 
    @user1.should be_valid
  end

  it "can have many runs" do 
    run = FactoryGirl.create(:run, user_id: @user1.id)
    second_run = FactoryGirl.create(:second_run, user_id: @user1.id)
    expect(@user1.runs.size).to eq 2
  end

  it "can count its friends" do
    expect(@user1.friends.count).to eq(2)
  end 

  it "can request a friend" do
    @user1.add_friend(@user4)
    @user1.add_friend(@user5)
    expect(@user1.total_pending_friends.count).to eq(3)
  end

  it "can count approved friends" do
    expect(@user1.total_approved_friends.count).to eq(3)
  end

  it "can approve a friend" do
    @user1.approve_friend(@user6)
    expect(@user1.total_approved_friends.count).to eq(4)
  end

  it "queries its approved friends" do
    expect(@user1.total_approved_friends).to include(@user2)
    expect(@user2.total_approved_friends).to include(@user1)
  end

end
