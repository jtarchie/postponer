# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def ensure_facebook_connect
    set_facebook_session()
    if facebook_session && facebook_session.user.id
      @user = User.find_or_create_by_facebook_id(facebook_session.user.id)
    else
      redirect_to :controller=>:account, :action=>:login, :next_url=>request.request_uri
    end
  end
end
