class UsersController < ApplicationController
  include UserHelper
  before_action :authenticate_user!
  before_action :set_user, :set_friendship, only: [:show]

  def index
    @users = User.all
  end

  def show
    set_friendship
    @posts = @user.posts.ordered_by_most_recent
  end
end
