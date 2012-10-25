class SessionsController < ApplicationController
  def new

  end

  def create
    begin
      user = User.find(params[:session][:username].downcase)
      rescue ActiveResource::ResourceNotFound => e
        flash[:error] = 'Wrong username/password'
        render 'new'
      else
        if user    #check the password
          sign_in user
          flash[:success] = 'Welcome back '+current_user.username
          redirect_to :controller => 'users', :action => 'show', :id => current_user.username
        else
          flash[:error] = 'Wrong username/password'
          render 'new'
        end
    end
  end

  def destroy
    sign_out
    flash[:notice] = 'See you soon!'
    redirect_to root_url
  end
end
