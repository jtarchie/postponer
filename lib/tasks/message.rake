namespace :message do
  namespace :send do
    desc "set status messages for facebook"
    task :facebook => [:environment] do |t|
      puts "#{Time.now}: Pushing messages to Facebook"
      count = Message.set_facebook_status(15.minutes.ago)
      puts "#{Time.now}: Sent total of #{count} messages(s)"
    end
  end
end