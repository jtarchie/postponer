class MessagesController < ApplicationController
  layout "default"
  before_filter :ensure_facebook_connect, :except => [:queued]
  before_filter :http_authenticate, :only => [:queued]
  
  # GET /messages
  # GET /messages.xml
  def index
    @messages = @user.messages.find(:all, :order=>'id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = @user.messages.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = @user.messages.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @message }
      format.js {render :layout => false}
    end
  end

  # GET /messages/1/edit
  def edit
    @message = @user.messages.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render :json => @message}
      format.js {render :layout => false}
    end
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = @user.messages.new(params[:message])

    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'
        format.html { redirect_to(@message) }
        format.json  { render :json => @message, :status => :created, :location => @message }
        format.js {render :status => :created}
      else
        format.html { render :action => "new" }
        format.json  { render :json => @message.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = @user.messages.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.json  { head :ok }
        format.js {render :status => :created}
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @message.errors, :status => :unprocessable_entity }
        formate.js
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = @user.messages.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.js { head :ok }
      format.json  { head :ok }
    end
  end
  
  def queued
    count = Message.set_facebook_status(15.minutes.ago)
    render :text => "Sent total of #{count} message(s)"
  end
  
  private
    def http_authenticate
      authenticate_or_request_with_http_basic do |user_name, password|
        user_name == HTTP_USERNAME && password == HTTP_PASSWORD
      end
    end
end
