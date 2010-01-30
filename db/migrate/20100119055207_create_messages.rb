class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.belongs_to  :user
      t.text        :body
      t.datetime    :scheduled_at
      t.datetime    :scheduled_at_local
      t.string      :timezone
      t.integer     :facebook_id, :limit => 8
      t.datetime    :delivered_at, :default => nil
      t.timestamps
    end
    
    add_index :messages, :user_id
    add_index :messages, :scheduled_at_local
  end

  def self.down
    drop_table :messages
  end
end
