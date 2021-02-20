class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships, {:id => false} do  |t|
      t.integer :sender_id, index: true
      t.integer :receiver_id, index: true
      t.boolean :status

      t.timestamps
    end
    execute "ALTER TABLE friendships ADD PRIMARY KEY (sender_id, receiver_id);"
  end
end
