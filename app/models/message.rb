class Message < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :body, :scheduled_at, :facebook_id
  
  before_save :set_defaults
  before_save :set_utc_offset
  
  def set_utc_offset
    if self.scheduled_at_changed?
      old_timezone = Time.zone
      Time.zone = self.timezone
      self.scheduled_at = Time.zone.parse(self.scheduled_at.to_s(:db))
      Time.zone = old_timezone
    end
  end
  
  def set_defaults
    self.timezone ||= 'Pacific Time (US & Canada)'
  end
  
  def self.set_facebook_status(time_ago = 5.minutes.ago, batch_limit = 50)
    session = Facebooker::Session.new(Facebooker.facebooker_config['api_key'],Facebooker.facebooker_config['secret_key'])
    Message.find_in_batches(:batch_size=>batch_limit, :conditions=>['? <= scheduled_at AND scheduled_at < ? AND delivered_by IS NULL', time_ago, Time.now.utc]) do |messages|
      Facebooker::Service.with_async do
        messages.each do |m|
          user = Facebooker::User.new(m.user.facebook_id, session)
          user.publish_to(user, {
            :post_as_page => true,
            :message => m.body,
            :uid => m.facebook_id
          })
        end
        Message.update_all ['id IN ?', messages.map(&:id)], ['delivered_at = ?', Time.now]
      end
    end
  end
end
