require 'rails_helper'

RSpec.describe User, type: :model do
  it 'user must have email' do
    @user = User.new(name: 'John', password: 'password')
    expect(@user.valid?).to be false
  end

  it 'user must have password' do
    @user = User.new(name: 'John', email: 'john@mail.com')
    expect(@user.valid?).to be false
  end
end
