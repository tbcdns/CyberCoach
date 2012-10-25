require 'rest-client'
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
      format.xml  { render :xml => @users}
      end
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = RestClient.put 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+params[:user][:username], {:password => params[:user][:password],:realname => params[:user][:realname],:email => params[:user][:email],:publicvisible => "2"}.to_json, :content_type => :json, :accept => :json

    flash[:success] = params[:user][:username]+' sucessfully created'
    redirect_to "/users/"+params[:user][:username]

    #@user = User.new(params[:user]).put(params[:user][:username])

  end

  def destroy
    #@user = User.find(params[:id])
    #@user.destroy
    begin
      RestClient.delete 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+params[:id]
      rescue Exception => e
        flash[:error] = 'Error : '+e.message
        redirect_to "/users/"
      else
        flash[:success] = 'User '+params[:id]+' sucessfully deleted'
        redirect_to "/users/"
    end


  end
end
