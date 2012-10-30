class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def add
    @events = Event.new
  end

  def show
  end

  def edit
  end
end
