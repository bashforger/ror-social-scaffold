module FriendshipsHelper

  def friendship_params
    params.permit(:sender_id, :receiver_id, :status)
  end

end
