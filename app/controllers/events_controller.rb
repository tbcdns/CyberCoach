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
    if @teams.nil?
      @teams[:team_nb] = 0
    end

    @team = Team.new

    if Team.where(:event_id => params[:id], :user_id => current_user).first.nil?
      @taking_part = false
    else
      @taking_part = false # ***should be true***
    end

    @matches = Match.where(:event_id => params[:id])
    @match = Match.new

    if @event.user_id == current_user
      @admin = true
    else
      @admin = false
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


  def close
    puts params[:id]
    Event.update(params[:id], :close => 1)

    flash[:success] = 'Event closed'
    redirect_to "/events/show/"+params[:id]
  end

end