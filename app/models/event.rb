class Event < ActiveRecord::Base
  attr_accessible :id, :name, :description, :sport_id, :nb_players, :begin, :end
end
