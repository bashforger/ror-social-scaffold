class FriendshipsController < ApplicationController
  include FriendshipsHelper
  before_action :set_friendship

  def index
    @friendships = Friendship.all
  end

  def show; end

  def new
    @friendship = Friendship.new
  end

  def create
    @friendship = Friendship.new(sender_id: params[:sender], receiver_id: params[:receiver])

    if @friendship.save
      flash[:notice] = 'Friendship was successfully created.'
    else
      flash[:alert] = 'Transaction failed.. Unable to create friendship!'
    end
    redirect_to request.referrer
  end

  def destroy_both
    @friendship = Friendship.where(sender_id: params[:receiver], receiver_id: params[:sender]).first
    if @friendship.destroy
      destroy
    else
      flash[:alert] = 'Transaction failed.. Unable to remove friendship!'
    end
    redirect_to request.referrer
  end

  def destroy
    @friendship = Friendship.where(sender_id: params[:sender], receiver_id: params[:receiver]).first

    if @friendship.destroy
      flash[:notice] = 'Friendship was successfully removed.'
    else
      flash[:alert] = 'Friendship not removed!'
    end
    redirect_to request.referrer
  end

end
