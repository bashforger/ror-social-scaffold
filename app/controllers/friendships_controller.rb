class FriendshipsController < ApplicationController
  include FriendshipsHelper

  def index
    @friendships = Friendship.all
  end

  def show; end

  def new; end

  def create
    @friendship = Friendship.new(sender_id: params[:sender], receiver_id: params[:receiver])
    logger.debug "New post: #{@friendship.attributes.inspect}"
    if @friendship.save
      flash[:notice] = 'Friendship was successfully created.'
    else
      flash[:alert] = "Transaction failed.. Unable to create friendship! #{@friendship}"
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

  def destroy_friendship
    @friendship = Friendship.where(sender_id: params[:receiver], receiver_id: params[:sender]).first
    if @friendship.destroy
      destroy
    else
      flash[:alert] = 'Friendship not removed!'
    end
  end

  def accept_request
    flash[:notice] = 'Update route hit successfully'
    @friendship = Friendship.new(sender_id: params[:receiver], receiver_id: params[:sender], status: true)
    if @friendship.save
      flash[:notice] = 'Created friendship successfully'
    else
      flash[:alert] = 'Something went wrong creating friendship'
    end
    @friendship = Friendship.where(sender_id: params[:sender], receiver_id: params[:receiver]).first
    @friendship.status = true if @friendship
    if @friendship.save
      flash[:notice] = 'Added as friend successfully'
    else
      flash[:alert] = 'Something went wrong Adding as friend'
    end
    redirect_to request.referrer
  end
end
