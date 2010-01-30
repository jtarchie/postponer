class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.belongs_to  :user
      t.text        :body
      t.datetime    :scheduled_at
      t.datetime    :scheduled_at_utc
      t.string      :timezone
      t.integer     :facebook_id, :limit => 8
      t.datetime    :delivered_at
      t.timestamps
    end
    
    add_index :messages, :user_id
    add_index :messages, :scheduled_at
  end

  def self.down
    drop_table :messages
  end
end
