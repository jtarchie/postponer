class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :facebook_id, :limit => 11
      t.timestamps
    end
    
    add_index :users, :facebook_id
  end

  def self.down
    drop_table :users
  end
end
