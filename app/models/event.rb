class Event < ActiveRecord::Base
  attr_accessible :id, :name, :description, :location, :sport_id, :nb_players, :nb_teams, :user_id, :begin, :end, :close
  has_many  :teams
  #has_many :users, :through => :teams
end
