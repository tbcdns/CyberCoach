class SportsController < ApplicationController

  def index
    @sports = Sport.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @sports }
      format.xml  { render :xml => @sports}
    end
  end


  def show
    @sport = Sport.find(params[:id])
  end

  def edit
  end
end
