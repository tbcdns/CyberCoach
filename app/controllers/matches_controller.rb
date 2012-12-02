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
    @match = Match.find(params[:id])
     sport = params[:sport_id].to_s()

    case sport
      when "Boxing" then
        formated_data = "#{params[:nb_rounds]};#{params[:round_duration]}"
      when "Cycling"
        formated_data = "#{params[:course_length]} ; #{params[:course_type]}"
      when "Running"
        formated_data = "#{params[:course_length]} ; #{params[:course_type]} ; #{params[:nb_rounds]}"
      when "Soccer"
        formated_data = "#{params[:score_team_1]} ; #{params[:score_team_2]}"
    end

    if @match.update_attributes({:winning_team_nb => params[:match][:winning_team_nb], :score => formated_data})
      flash['formated_data'] = formated_data
      redirect_to :action => 'update_score', :id => params[:id]
    end
  end

  def simulate

      redirect_to :action => 'update_score', :id => 1

  end

  def update_score #mise a jour du score + push des résultats pour chaque utilisateur
    formated_data = flash['formated_data']
    match = Match.find(params[:id])
    event = Event.find(match.event_id) #on charge l'event auquel appartient le match
    comment = event.description
    entryduration = 10 #todo comment calculer la durée?
    entrylocation = event.location
    publicvisible = 2
    sport = event.sport_id

    #TODO: les parametres doivent etre transférés et pas codés en dur
    courselength = 600
    track = nil

    case sport
      when "Boxing" then
        variable_data = formated_data.split(';')
        formated_data = {:comment => comment, :entrydate => DateTime.now, :entryduration => entryduration, :entrylocation => entrylocation, :publicvisible => publicvisible, :numberofrounds => variable_data[0], :roundduration => variable_data[1]}
      when "Cycling"
        variable_data = formated_data.split(';')
        formated_data = {:comment => comment, :entrydate => DateTime.now, :entryduration => entryduration, :entrylocation => entrylocation, :publicvisible => publicvisible, :bicycletype => variable_data[0], :courselength => variable_data[1], :coursetype => variable_data[2], :numberofrounds => variable_data[3]}
      when "Running"
        variable_data = formated_data.split(';')
        formated_data = {:comment => comment, :entrydate => DateTime.now, :entryduration => entryduration, :entrylocation => entrylocation, :publicvisible => publicvisible, :courselength => variable_data[0], :coursetype => variable_data[1], :numberofrounds => variable_data[2]}
      when "Soccer"
        formated_data = {:comment => comment, :entrydate => DateTime.now, :entryduration => entryduration, :entrylocation => entrylocation, :publicvisible => publicvisible}
    end

    ##Fred
    match_id = params[:id]
    match = Match.find(match_id) #load the match which has just been finished
    team1_id = match.team1_nb #load both teams
    team2_id = match.team2_nb
    puts "Team 1 : #{team1_id} / Team 2 : #{team2_id}"

    team1 = Team.all( :conditions => {:team_nb => team1_id, :event_id => match.event})
    team2 = Team.all( :conditions => {:team_nb => team2_id, :event_id => match.event})

    for t1 in team1 #on parcourt tous les joueurs de l'équipe 1 de ce match

      #on essaie d'ajouter une entry
      begin
        user_local  = User_local.find_by_name(t1.user_id)

        digest = Base64.encode64(t1.user_id+':'+user_local.password)

        formated_data = JSON.parse(formated_data.to_json).to_xml(:root => "entry#{sport.downcase}")

        #Logging
        puts "url: " + 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+t1.user_id+'/'+sport
        puts formated_data
        #Logging

        #Posting XML
        RestClient.post 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+t1.user_id+'/'+sport, formated_data , :content_type => 'application/xml', :accept => 'application/xml', :Authorization => 'Basic '+digest
        #Logging if it worked
        puts "**** Entry added for " + t1.user_id + " ****"

      rescue Exception => e #if the user hasn't subscribed yet
        puts e.message
        begin
          puts "**** User " + t1.user_id + " not registered for " + sport + " ****"  + digest

          flash[:error] = e.message

          data_subscription = {:publicvisible => 2}
          data_subscription = JSON.parse(data_subscription.to_json).to_xml(:root => :subscription)
          puts "*** Trying to add theses data : " + data_subscription

          RestClient.put 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+ t1.user_id + '/' + sport, data_subscription, :content_type => :xml, :accept => :xml, :Authorization => 'Basic '+digest
        rescue Exception => e2
          puts "** Subscription didn't work: " + e2.message

        end
        #Logging if subscribtion worked
        puts "**** Subscription added for " + t1.user_id + " for " + sport + " ****"

        #Posting XML
        RestClient.post 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+t1.user_id+'/'+sport, formated_data , :content_type => 'application/xml', :accept => 'application/xml', :Authorization => 'Basic '+digest
        #Logging if it worked
        puts "**** Entry added for " + t1.user_id + " ****"


        # else
        #   flash[:success] = params[:user][:username]+' sucessfully created'
        #   redirect_to "/users/"+params[:user][:username]
      end
      #si erreur, l'utilisateur doit d'abord souscrire à un sport


    end



    for t2 in team2 #on parcourt tous les joueurs de l'équipe 1 de ce match

      #on essaie d'ajouter une entry
      begin
        user_local  = User_local.find_by_name(t2.user_id)

        digest = Base64.encode64(t2.user_id+':'+user_local.password)

        formated_data = JSON.parse(formated_data.to_json).to_xml(:root => "entry#{sport.downcase}")

        #Logging
        puts "url: " + 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+t2.user_id+'/'+sport
        puts formated_data
        #Logging

        #Posting XML
        RestClient.post 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+t2.user_id+'/'+sport, formated_data , :content_type => 'application/xml', :accept => 'application/xml', :Authorization => 'Basic '+digest
        #Logging if it worked
        puts "**** Entry added for " + t2.user_id + " ****"

      rescue Exception => e #if the user hasn't subscribed yet
        puts e.message
        begin
          puts "**** User " + t2.user_id + " not registered for " + sport + " ****"  + digest

          flash[:error] = e.message

          data_subscription = {:publicvisible => 2}
          data_subscription = JSON.parse(data_subscription.to_json).to_xml(:root => :subscription)
          puts "*** Trying to add theses data : " + data_subscription

          RestClient.put 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+ t2.user_id + '/' + sport, data_subscription, :content_type => :xml, :accept => :xml, :Authorization => 'Basic '+digest
        rescue Exception => e2
          puts "** Subscription didn't work: " + e2.message

        end
        #Logging if subscribtion worked
        puts "**** Subscription added for " + t2.user_id + " for " + sport + " ****"

        #Posting XML
        RestClient.post 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/'+t2.user_id+'/'+sport, formated_data , :content_type => 'application/xml', :accept => 'application/xml', :Authorization => 'Basic '+digest
        #Logging if it worked
        puts "**** Entry added for " + t2.user_id + " ****"


        # else
        #   flash[:success] = params[:user][:username]+' sucessfully created'
        #   redirect_to "/users/"+params[:user][:username]
      end
      #si erreur, l'utilisateur doit d'abord souscrire à un sport


    end

    flash[:success] = "Scores successfully added to each player"
    redirect_to '/'
    ##Fred END

  end

end