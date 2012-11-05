require 'rest-client'
require 'base64'
class SessionsController < ApplicationController
  def new
    @skip_login = true
  end

  def create
    @skip_login = true
    begin
      user = User.find(params[:session][:username].downcase)
      digest = Base64.encode64(params[:session][:username].downcase+':'+params[:session][:password])
      testResponse = RestClient.put 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+params[:session][:username], {:publicvisible => user.publicvisible}.to_json, :content_type => :json, :accept => :json, :Authorization => 'Basic '+digest

    rescue Exception => e
        flash[:error] = 'Wrong username/password'
        render 'new'
      else
        if user    #check the password
          sign_in user
          flash[:success] = 'Welcome back '+current_user.username.to_s
          redirect_to :controller => 'users', :action => 'show', :id => current_user.username
        else
          flash[:error] = 'Wrong username/password'
          render 'new'
        end
    end
  end

  def destroy
    sign_out
    flash[:notice] = 'See you soon !'
    redirect_to root_url
  end
end
