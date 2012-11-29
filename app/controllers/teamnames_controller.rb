class TeamnamesController < ApplicationController
  def new
   @teamName = Teamname.new
  end

  def create
    @teamName = Teamname.new(:event_id => params[:teamname][:event_id] , :team_nb => params[:teamname][:team_nb], :name => params[:teamname][:name])
    begin
      @teamName.save
    rescue Exception => e
      puts "Error"+e.message
    end
  end

  def update
    @teamName = Teamname.find(params[:teamname][:id])

    if @teamName.update_attribute(:name, params[:teamname][:name])
      alert "success"
    end
  end
end