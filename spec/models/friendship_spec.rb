require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { User.new(name: 'John', email: 'john@mail.com', password: 'password') }
  let(:friend) { User.new(name: 'Tim', email: 'tim@mail.com', password: 'password') }
  let(:friendship) { Friendship.create(sender: user, receiver: friend) }

  it 'creates a valid friendship' do
    expect(friendship.valid?).to be true
  end

  it 'sends a friendship correctly' do
    expect(user.sent_requests.include?(friendship)).to be true
  end

  it 'receives a friendship correctly' do
    expect(friend.received_requests.include?(friendship)).to be true
  end

  it 'creates a friendship through user' do
    new_friendship = user.sent_requests.build(sender: user, receiver: friend)
    expect(new_friendship.valid?).to be true
  end
end
