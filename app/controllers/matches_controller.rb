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

  def simulate

      redirect_to :action => 'update_score', :id => 1

  end

  def update_score #mise a jour du score + push des résultats pour chaque utilisateur

    ##Fred
    match_id = params[:id]
    match = Match.find(match_id) #load the match which has just been finished
    team1_id = match.team1_nb #load both teams
    team2_id = match.team2_nb

    team1 = Team.all( :conditions => {:team_nb => team1_id})
    team2 = Team.all( :conditions => {:team_nb => team2_id})

    for t1 in team1 #on parcourt tous les joueurs de l'équipe 1 de ce match

      #TODO: les parametres doivent etre transférés et pas codés en dur
      sport = "Running"
      comment = "my Comment"
      entryduration = 1000
      entrylocation = "Fribourg"
      publicvisible = 2
      courselength = 600
      coursetype = "Outdoor"
      numberofrounds = 12
      track = nil
      #on essaie d'ajouter une entry
      begin
        #TODO : Probleme pour ajouter une entree (ou meme souscrire à un sport), il faut le mot de passe qui n'est pas disponible
        digest = Base64.encode64(t1.user_id+':'+User.find(t1.user_id).password)
        RestClient.post 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+t1.user_id+'/'+sport, {:entryrunning => {:comment => comment,:entrydate => DateTime.now, :entryduration => entryduration, :entrylocation => entrylocation, :publicvisible => publicvisible, :courselength => courselength, :coursetype => coursetype, :numberofrounds => numberofrounds, :track => track}}.to_json, :content_type => :json, :accept => :json, :Authorization => 'Basic '+digest
      rescue Exception => e
        flash[:error] = e.message
        puts e.message
        puts "
****
#{YAML::dump(t1)}
****"
        #redirect_to '/users/add'
      else
        flash[:success] = params[:user][:username]+' sucessfully created'
        redirect_to "/users/"+params[:user][:username]
      end
      #si erreur, l'utilisateur doit d'abord souscrire à un sport


    end

    ##Fred END

  end

end