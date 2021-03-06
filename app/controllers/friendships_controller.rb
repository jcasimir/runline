class FriendshipsController < ApplicationController

  def index
    @user = current_user
    @friendship = Friendship.new
  end

  def create
    if current_user.add_friend(friend)
      flash.notice = "Your request to #{friendship_params} has been sent!"
    else
       flash.notice = "Could not find user: #{friendship_params}"      
    end
    redirect_to :back
  end

  def approve
    friendship = current_user.total_pending_friendships.find(params[:id]).first
    friendship.approve
    flash.notice = "Congrats on having a new friend! You're on your way to being a running social butterfly!"
    redirect_to :back
  end

  def remove
    friendship = current_user.total_approved_friendships.find(params[:id]).first
    friendship.remove
    flash.notice = "You just showed them who the boss was!"
    redirect_to :back
  end

  def reject
    friendship = current_user.total_pending_friendships.find(params[:id]).first
    friendship.reject
    flash.notice = "REJECTED!!!"
    redirect_to :back
  end

  private

  def friendship_params
    params.require(:friendship).require(:friend_name)
  end

  def friend
    User.find_by(username: friendship_params)
  end

end
