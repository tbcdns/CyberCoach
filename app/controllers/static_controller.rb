class StaticController < ApplicationController
  def home
    if(signed_in?)
    @my_events = Event.find_all_by_user_id(current_user)
    @recent_events = Event.order(:begin).where(:close => 0).limit(5)



    end
    @skip_login = true
  end

  def stats
    if(signed_in?)
    @boxing = Subscription.find(:all, :params => {:sport => "Boxing", :user => current_user, :start => 0, :size => 500 })
    @soccer = Subscription.find(:all, :params => {:sport => "Soccer", :user => current_user, :start => 0, :size => 500 })
    @cycling = Subscription.find(:all, :params => {:sport => "Cycling", :user => current_user, :start => 0, :size => 500 })
    @running = Subscription.find(:all, :params => {:sport => "Running", :user => current_user, :start => 0, :size => 500 })

    #TODO petit bug : le nombre de matches joués (camambert) est calculé a partir des réponses REST (serveur distant). Au contraire, le nombre de matches gagnés et perdus et calculé a partir de la BDD locale.
    # Si le nb d'entries diverge, les stastiques ne seront pas synchro

    ####### Chargement des entries pour chaque sport
    @boxing_entries = Array.new
    if !@boxing.nil?
      @boxing.each do |b|
        @boxing_entries.push(Entry.find(:all, :params => {:sport => "Boxing", :user => current_user, :entry_id => b.entryboxing.id}))
      end
    end

    @soccer_entries = Array.new
    if !@soccer.nil?
      @soccer.each do |b|
        @soccer_entries.push(Entry.find(:all, :params => {:sport => "Soccer", :user => current_user, :entry_id => b.entrysoccer.id}))
      end
    end

    @cycling_entries = Array.new
    if !@cycling.nil?
      @cycling.each do |b|
        @cycling_entries.push(Entry.find(:all, :params => {:sport => "Cycling", :user => current_user, :entry_id => b.entrycycling.id}))
      end
    end

    @running_entries = Array.new
    if !@running.nil?
      @running.each do |b|
        @running_entries.push(Entry.find(:all, :params => {:sport => "Running", :user => current_user, :entry_id => b.entryrunning.id}))
      end
    end

    ####### END Chargement des entries pour chaque sport


    @my_teams = Team.all(:conditions => {:user_id => current_user})

    @my_won_boxing_matches = @my_lost_boxing_matches = 0
    @my_won_soccer_matches = @my_lost_soccer_matches = 0
    @my_won_cycling_matches = @my_lost_cycling_matches = 0
    @my_won_running_matches = @my_lost_running_matches = 0

    @my_teams.each do |team| #on cherche toutes les équipes dont je fais partie
      sport_type = Event.find_by_id(team.event_id) #on extrait le sport
      sport_type = sport_type.sport_id
      puts "team : #{team.team_nb} and event #{team.event_id}"

      #on sauvegarde tous les matches dans un array
      my_matches = Match.all(:conditions => ['event_id = ? AND (team1_nb = ? OR team2_nb = ?)',team.event_id, team.team_nb, team.team_nb] )
      @my_matches = my_matches
      if sport_type == "Boxing"
        my_matches.each do |m| #on parcourt chaque match d'un tournoi (event_id = x) auquel j'ai participé (team1 ou team2 est la mienne)
          if m.winning_team_nb == team.team_nb #on regarde si mon équipe a gagné
            @my_won_boxing_matches += 1
          elsif m.winning_team_nb != nil
            @my_lost_boxing_matches += 1
          end
        end
      end


      if sport_type == "Soccer"
        my_matches.each do |m| #on parcourt chaque match d'un tournoi (event_id = x) auquel j'ai participé (team1 ou team2 est la mienne)
          if m.winning_team_nb == team.team_nb #on regarde si mon équipe a gagné
            @my_won_soccer_matches += 1
          else
            @my_lost_soccer_matches += 1
          end
        end
      end


      if sport_type == "Cycling"
        my_matches.each do |m| #on parcourt chaque match d'un tournoi (event_id = x) auquel j'ai participé (team1 ou team2 est la mienne)
          if m.winning_team_nb == team.team_nb #on regarde si mon équipe a gagné
            @my_won_cycling_matches += 1
          elsif m.winning_team_nb != nil
            @my_lost_cycling_matches += 1
          end
        end
      end

      if sport_type == "Running"
        my_matches.each do |m| #on parcourt chaque match d'un tournoi (event_id = x) auquel j'ai participé (team1 ou team2 est la mienne)
          if m.winning_team_nb == team.team_nb #on regarde si mon équipe a gagné
            @my_won_running_matches += 1
          elsif m.winning_team_nb != nil
            @my_lost_running_matches += 1
          end
        end
      end



    end

    if !@boxing.nil?
      @nb_boxing = @boxing.size
    else
      @nb_boxing = 0
    end

    if !@soccer.nil?
      @nb_soccer = @soccer.size
    else
      @nb_soccer = 0
    end

    if !@cycling.nil?
      @nb_cycling = @cycling.size
    else
      @nb_cycling = 0
    end

    if !@running.nil?
      @nb_running = @running.size
    else
      @nb_running = 0
    end

    @nb_total = @nb_boxing + @nb_cycling + @nb_running + @nb_soccer


    puts "total "+@nb_total.to_s
  end
  @skip_footer = true
  @skip_top = true
  end
end
