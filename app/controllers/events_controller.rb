
class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
    @sports = Sport.find(:all)
    if !signed_in?
      flash[:error]  = 'You must be logged in to create a new event'
      redirect_to "/signin"
    end
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:success] = 'Event created'
       redirect_to @event
    else
      flash[:error] = 'Error'
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
    @teams = Team.where(:event_id => params[:id])
    @team = Team.new
    if Team.where(:event_id => params[:id], :user_id => current_user).first.nil?
      @taking_part = false
    else
      @taking_part = false #should be true
    end


    begin
      puts "test"
      @event = Event.find_by_id(params[:id], :include => [:teams])


    rescue Exception => e
      flash[:error] = e.message
      redirect_to '/events/'
    end
  end

  def edit
  end

end