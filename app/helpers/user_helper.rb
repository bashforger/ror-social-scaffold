module UserHelper

  def set_user
    @user = User.find(params[:id])
  end

  def set_friendship
    @friendship = current_user.received_requests.select { |r|  r.sender_id == @user.id }[0]
  end

  def is_friend?
    @friendship.status if @friendship
  end

  def request_sent?(user)
    @user = user
    @user.received_requests.any? { |request| (request.sender_id == current_user[:id]) }
  end

  def request_sent_status?
    @user.received_requests.select { |request| (request.sender_id == current_user[:id]) }[0].status
  end

  def request_received?(user)
    @user = user
    @user.sent_requests.any? { |request| (request.receiver_id == current_user[:id]) }
  end

  def request_received_status?
    @user.sent_requests.select { |request| (request.receiver_id == current_user[:id]) }[0].status
  end

  def no_request?(user)
    @user = user
    !request_sent?(@user) && !request_received?(@user) && @user != current_user
  end

  def friendship_controls
    html_out = ''
    if @user.id != current_user[:id]
      if request_sent?(@user) && request_received?(@user)
        html_out << "<div>Your Friend.</div><%= link_to 'Remove as friend', :controller => 'friendships',
                        :action => 'destroy_both', :sender => current_user, :receiver => @user, :redirect_user => @user %>"
      elsif request_sent?(@user)
        html_out << "<%= link_to 'Remove Friendship', friendship_path(:sender => @user, :receiver => current_user), method: :delete, data: { confirm: 'Are you sure?' } %>" if is_friend?
        html_out << "<%= link_to 'Cancel Friend Request', friendship_path(:sender => current_user, :receiver => @user), method: :delete, data: { confirm: 'Are you sure?' } %>"
      elsif request_received?(@user)  && is_friend?
        html_out << "<%= link_to 'Remove Friendship', friendship_path(:sender => @user, :receiver => current_user), method: :delete, data: { confirm: 'Are you sure?' } %>"
      elsif request_received?(@user)
        html_out << "<div>You received friend request from <%= @user.name %>.</div>
                          <%= link_to 'Approve Friend Request', accept_path(:sender => @user, :receiver => current_user), method: :post %><br>
                          <%= link_to 'Cancel Friend Request', friendship_path(:sender => current_user, :receiver => @user), method: :delete, data: { confirm: 'Are you sure?' } %>"
      else
        html_out << "<%= link_to 'Send Friend Request', friendships_path(:sender => current_user, :receiver => @user, :status => false), status: false, method: 'post' if no_request?(@user) %>"
      end
    end
    render inline: html_out
  end

  def friendship_controls_index(user)
    @user = user
    html_out = ''
    if @user != current_user
      if no_request?(@user)
        html_out <<  "<strong><%= link_to 'Send Friend Request', friendships_path(:sender => current_user, :receiver => @user, :status => false), status: false, method: 'post', class: 'profile-link'%></strong>"
      elsif request_sent?(@user) && request_sent_status?
        html_out <<  "<strong><%= link_to 'Friend',  user_path(@user), class: 'profile-link' %></strong>"
      elsif request_received?(@user) && request_received_status?
        html_out <<  "<strong><%= link_to 'Friend',  user_path(@user), class: 'profile-link' %></strong>"
      else
        html_out <<  "<strong><%= link_to 'Pending Request',  user_path(@user), class: 'profile-link' %></strong>"
      end
    end
    render inline: html_out
  end
end
