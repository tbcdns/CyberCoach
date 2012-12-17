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
      @boxing = Subscription.find(:all, :params => {:sport => "Boxing", :user => @user.username, :start => 0, :size => 500 })
      @soccer = Subscription.find(:all, :params => {:sport => "Soccer", :user => @user.username, :start => 0, :size => 500 })
      @cycling = Subscription.find(:all, :params => {:sport => "Cycling", :user => @user.username, :start => 0, :size => 500 })
      @running = Subscription.find(:all, :params => {:sport => "Running", :user => @user.username, :start => 0, :size => 500 })


      @boxing_entries = Array.new
      if !@boxing.nil?
        @boxing.each do |b|
          @boxing_entries.push(Entry.find(:all, :params => {:sport => "Boxing", :user => @user.username, :entry_id => b.entryboxing.id}))
        end
      end

      @soccer_entries = Array.new
      if !@soccer.nil?
        @soccer.each do |b|
          @soccer_entries.push(Entry.find(:all, :params => {:sport => "Soccer", :user => @user.username, :entry_id => b.entrysoccer.id}))
        end
      end

      @cycling_entries = Array.new
      if !@cycling.nil?
        @cycling.each do |b|
          @cycling_entries.push(Entry.find(:all, :params => {:sport => "Cycling", :user => @user.username, :entry_id => b.entrycycling.id}))
        end
      end

      @running_entries = Array.new
      if !@running.nil?
        @running.each do |b|
          @running_entries.push(Entry.find(:all, :params => {:sport => "Running", :user => @user.username, :entry_id => b.entryrunning.id}))
        end
      end

    rescue Exception => e
      flash[:error] = "Error : "+e.message
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
    flash[:success] = params[:user][:username]+' sucessfully created, please login'
    redirect_to "/signin"
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
