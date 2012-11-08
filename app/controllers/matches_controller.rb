class MatchesController < ApplicationController
  def new

  end

  def create
    infos_event = Event.find(params[:match][:event_id])
    infos_match = Match.where(:event_id => params[:match][:event_id])
    date = params[:match][:date]
    if infos_match.nil?
      teams = (1..infos_event.nb_teams).to_a.shuffle
      i=1
      for t_nb in teams do
        if i.odd?
          team1 = t_nb
        else
          team2 = t_nb
          @match = Match.new(:event_id => params[:match][:event_id], :team1_nb => team1, :team2_nb => team2, :score => nil, :winning_team_nb => nil, :date => date)
          if @match.save
            #do something
          else
            #error
          end
        end


        i += 1
      end
      #generate first round
    else
      #check for previous matches
      #compter le nombre d'equipe restantes
      #creer un tableau des equipes.shuffle
      #ajouter equipe
    end
  end

end