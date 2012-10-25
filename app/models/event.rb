class Event < ActiveRecord::Base
  attr_accessible :id, :name, :sport_id, :nb_players, :begin, :end
end
