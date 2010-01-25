class User < ActiveRecord::Base
  has_many :messages
  
  validates_presence_of :facebook_id
end
