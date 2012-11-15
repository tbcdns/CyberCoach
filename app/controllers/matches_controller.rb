class MatchesController < ApplicationController
  def new
    @match = Match.new
  end

  def create
    infos_event = Event.find(params[:match][:event_id])
    infos_match = Match.where(:event_id => params[:match][:event_id])
    date = params[:match][:date]

    if infos_match.empty? # true => it's the first round
      teams = (1..infos_event.nb_teams).to_a.shuffle
      i=1

      for t_nb in teams do
        if i.odd?
          team1 = t_nb
        else
          team2 = t_nb
          @match = Match.new(:event_id => params[:match][:event_id], :team1_nb => team1, :team2_nb => team2, :score => nil, :winning_team_nb => nil, :date => date, :level => 1)
          @match.save

        end
      i += 1

      end
      flash[:success] = "New matches"+params[:match][:event_id]
      redirect_to "/events/"
      #generate first round
    else
      #check for previous matches
      #compter le nombre d'equipe restantes
      #creer un tableau des equipes.shuffle
      #ajouter equipe
      level = Match.where(:event_id => params[:match][:event_id]).order(:level).reverse.first.level
      winners = []
      for winner in Match.where(:event_id => params[:match][:event_id], :level => level) do
        winners.push(winner.winning_team_nb)#ajouter les equipes gagnantes dans le tableau
      end

      winners.shuffle # mélanger le tableau

      i=1

      for t_nb in winners do
        if i.odd?
          team1 = t_nb
        else
          team2 = t_nb
          @match = Match.new(:event_id => params[:match][:event_id], :team1_nb => team1, :team2_nb => team2, :score => nil, :winning_team_nb => nil, :date => date, :level => (level+1))
          @match.save

        end
        i += 1
      end

      flash[:success] = "level : "+level.to_s
      redirect_to "/events/"
    end
  end

  def update

  end

end