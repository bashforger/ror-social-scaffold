module FriendshipsHelper

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:sender_id, :receiver_id, :status)
  end
end
