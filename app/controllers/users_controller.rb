require 'rest-client'
class UsersController < ApplicationController
  def new
    @skip_login = true
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
    begin
      @user = User.find(params[:id])
      @boxing = Subscription.find(:all, :params => {:sport => "Boxing", :user => @user.username })
      @entries = Array.new
  @boxing.each do |b|

     @entries = Entry.find(:all, :params => {:sport => "Boxing", :user => @user.username, :entry_id => b.id })
     puts "entries : #{@entries}"

  end

    rescue Exception => e
      flash[:error] = e.message
      redirect_to '/users/'
    end
  end

  def create
    @skip_login = true
    begin
      dat = {:password => params[:user][:password],:realname => params[:user][:realname],:email => params[:user][:email],:publicvisible => "2"}
      puts JSON.pretty_generate(dat)
    @user = RestClient.put 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+params[:user][:username], {:password => params[:user][:password],:realname => params[:user][:realname],:email => params[:user][:email],:publicvisible => "2"}.to_json, :content_type => :json, :accept => :json
    rescue Exception => e
    flash[:error] = e.message
    redirect_to '/users/add'
    else
    flash[:success] = params[:user][:username]+' sucessfully created'
    redirect_to "/users/"+params[:user][:username]
    end
    #@user = User.add(params[:user]).put(params[:user][:username])

  end

  def destroy
    require "base64"
    #@user = User.find(params[:id])
    #@user.destroy
    begin
      @user = User.find(params[:id])
      digest = Base64.encode64(params[:id]+':'+User.find(params[:id]).password)
      RestClient.delete 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+params[:id], :Authorization => 'Basic '+digest
      rescue Exception => e
        flash[:error] = 'Error : '+e.message
        redirect_to "/users/"
      else
        flash[:success] = 'User '+params[:id]+' sucessfully deleted'
        redirect_to "/users/"
    end


  end
end
