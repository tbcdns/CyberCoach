class StaticController < ApplicationController
  def home
    @my_events = Event.find_all_by_user_id(current_user)
    @recent_events = Event.order(:begin).where(:close => 0).limit(5)

    @boxing = Subscription.find(:all, :params => {:sport => "Boxing", :user => current_user, :start => 0, :size => 500 })
    @soccer = Subscription.find(:all, :params => {:sport => "Soccer", :user => current_user, :start => 0, :size => 500 })
    @cycling = Subscription.find(:all, :params => {:sport => "Cycling", :user => current_user, :start => 0, :size => 500 })
    @running = Subscription.find(:all, :params => {:sport => "Running", :user => current_user, :start => 0, :size => 500 })


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


    puts "total #{@nb_total}"

    @skip_login = true
  end
end
