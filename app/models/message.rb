class Message < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :body, :scheduled_at, :facebook_id
  
  before_save :set_defaults
  before_save :set_utc_offset
  
  def set_utc_offset
    if self.scheduled_at_changed? || self.timezone_changed?
      self.scheduled_at_local = Time.parse(self.scheduled_at.to_s(:db)).in_time_zone(self.timezone)
    end
  end
  
  def set_defaults
    self.timezone ||= 'Pacific Time (US & Canada)'
  end
  
  def self.set_facebook_status(time_ago = 5.minutes.ago, batch_limit = 50)
    count = 0
    session = Facebooker::Session.new(Facebooker.facebooker_config['api_key'],Facebooker.facebooker_config['secret_key'])
    Message.find_in_batches(:batch_size=>batch_limit, :conditions=>['? <= scheduled_at_local AND scheduled_at_local < ? AND delivered_at IS NULL', time_ago, Time.now.utc]) do |messages|
      Facebooker::Service.with_async do
        messages.each do |m|
          user = Facebooker::User.new(m.user.facebook_id, session)
          user.publish_to(user, {
            :post_as_page => true,
            :message => m.body,
            :uid => m.facebook_id
          })
        end
        Message.update_all({:id=>messages.map{|m|m.id}}, ['delivered_at = ?', Time.now])
        count += messages.length
      end
    end
    return count
  end
end
