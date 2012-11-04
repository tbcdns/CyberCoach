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
  end

  def update
  end
end
