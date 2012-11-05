class StaticController < ApplicationController
  def home
    @my_events = Event.find_all_by_user_id(current_user)
    @recent_events = Event.order(:begin).where(:close => 0).limit(5)
    @skip_login = true
  end
end
