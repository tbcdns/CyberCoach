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
    @user = User.new(params[:user]).put(:username)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end


# TODO test, signup
# TODO test fred
end
