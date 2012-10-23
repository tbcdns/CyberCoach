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
    require 'rest-client'
    putrequest = RestClient.put 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+params[:user][:username], {:password => params[:user][:password],:realname => params[:user][:realname],:email => params[:user][:email],:publicvisible => "2"}.to_json, :content_type => :json, :accept => :json

    redirect_to "/users/"+params[:user][:username], flash[:notice] => params[:user][:username]+' sucessfully created'

    #@user = User.new(params[:user]).put(params[:user][:username])

  end

  def destroy
    require 'rest-client'
    @user = RestClient.delete 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+params[:id]
    redirect_to "/users/"
  end
end
