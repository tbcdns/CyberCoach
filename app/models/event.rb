class Event < ActiveRecord::Base
  attr_accessible :id, :name, :sport_id, :nb_players, :nb_teams, :begin, :end, :description, :user_id, :close
end
