class TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    event_infos = Event.find(params[:team][:event_id])
    nb_players = event_infos.nb_players
    nb_teams = event_infos.nb_teams
    team_nb = Team.where(:event_id => params[:team][:event_id]).order(:team_nb).reverse.first

    if team_nb.nil?
      team_nb = 1
    else
      team_nb = team_nb.team_nb
    end

    actual_team_nb_player = Team.where(:event_id => params[:team][:event_id], :team_nb => team_nb).order(:team_nb).all.reverse.count()
    free_space = nb_players - actual_team_nb_player

    if free_space == 0
      team_nb += 1
    end

    @team = Team.new(:event_id => params[:team][:event_id], :user_id => current_user, :team_nb => team_nb)
      if @team.save
        flash[:success] = "You're taking part at this event!"
        if free_space == 1 && team_nb+1 > nb_teams
          Event.update(params[:team][:event_id], :close => 1)
        end
        redirect_to "/events/"+params[:team][:event_id]
      else
        flash[:error] = "Problem occurred"
        redirect_to "/events/"+params[:team][:event_id]
      end

  end
end