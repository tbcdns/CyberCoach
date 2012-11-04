class SportsController < ApplicationController

  def index
    @sports = Sport.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @sports }
      format.xml  { render :xml => @sports}
    end
  end

  def new
    @sport = Sport.new
    @skip_footer = true
  end

  def create
    begin
      @sport = RestClient.put 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/sports/', {:name => params[:sport][:name],:description => params[:sport][:description]}.to_json, :content_type => :json, :accept => :json
    rescue Exception => e
      flash[:error] = e.message
      redirect_to '/sports/'
    else
      flash[:success] = params[:sport][:name]+' sucessfully created'
      redirect_to "/sports/"
    end
  end

  def show
    @sport = Sport.find(params[:id])
  end

  def edit
  end
end
