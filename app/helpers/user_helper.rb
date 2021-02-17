# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
module UserHelper
  def set_user
    @user = User.find(params[:id])
  end

  def set_friendship
    @friendship = if request_sent?(@user)
                    @user.received_requests.select { |request| (request.sender_id == current_user[:id]) }[0]
                  elsif request_received?(@user)
                    @user.sent_requests.select { |request| (request.receiver_id == current_user[:id]) }[0]
                  end
  end

  def friend?
    @friendship&.status
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
                        :action => 'destroy_both', :sender => current_user, :receiver => @user,
                        :redirect_user => @user %>"
      elsif request_sent?(@user)
        html_out << if friend?
                      "<%= link_to 'Remove Friend', friendship_path(:sender => @user, :receiver => current_user),
                       method: :delete, data: { confirm: 'Are you sure?' }, class: 'text-danger' %>"
                    else
                      "<%= link_to 'Cancel Friend Request', friendship_path(:sender => current_user,
                           :receiver => @user), method: :delete, data: { confirm: 'Are you sure?' },
                           class: 'text-danger' %>"
                    end
      elsif request_received?(@user) && friend?
        html_out << "<%= link_to 'Remove Friend', friendship_path(:sender => @user, :receiver => current_user),
                         method: :delete, data: { confirm: 'Are you sure?' }, class: 'text-danger' %>"
      elsif request_received?(@user)
        if friend?
          html_out << "<%= link_to 'Remove Friend', friendship_path(:sender => @user, :receiver => current_user),
                       method: :delete, data: { confirm: 'Are you sure?' }, class: 'text-danger' %>"
        else
          html_out << "<div class='text-success'>You received friend request from
                          <strong><%= @user.name %></strong>.</div>
                          <%= link_to 'Approve Friend Request', accept_path(:sender => @user,
                          :receiver => current_user), method: :post, class: 'text-success' %><br>
                          <%= link_to 'Remove Friendship', friendship_path(:sender => @user, :receiver => current_user),
                           method: :delete, data: { confirm: 'Are you sure?' }, class: 'text-danger' %>"
        end
      else
        html_out << "<%= link_to 'Send Friend Request', friendships_path(:sender => current_user, :receiver => @user,
                     :status => false), status: false, method: 'post' if no_request?(@user) %>"
      end
    end
    render inline: html_out
  end

  def friendship_controls_index(user)
    @user = user
    html_out = ''
    if @user != current_user
      html_out << if no_request?(@user)
                    "<strong><%= link_to 'Send Friend Request', friendships_path(:sender => current_user,
                     :receiver => @user, :status => false), status: false, method: 'post',
                      class: 'profile-link'%></strong>"
                  elsif request_sent?(@user) && request_sent_status?
                    "<strong><%= link_to 'Friend',  user_path(@user), class: 'profile-link' %></strong>"
                  elsif request_received?(@user) && request_received_status?
                    "<strong><%= link_to 'Friend',  user_path(@user), class: 'profile-link' %></strong>"
                  else
                    "<strong><%= link_to 'Pending Request',  user_path(@user), class: 'profile-link' %></strong>"
                  end
    end
    render inline: html_out
  end
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
