
class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def add
    @events = Event.new()
    if params[:event] #if the form has been submitted
      @events = Event.new(params[:event])
      if @events.save
        redirect_to :action => "index"
      else
        redirect_to :action => "index"
      end
    end

      rescue Exception => e
      flash[:error] = e.message

    logger.info("
    ############
    #{YAML::dump(params[:event][:name])}
    ############
    ")
    #params[:user][:username]

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
    @team = Team.new
    if Team.where(:event_id => params[:id], :user_id => current_user).first.nil?
      @taking_part = false
    else
      @taking_part = true
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