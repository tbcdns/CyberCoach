class Match < ActiveRecord::Base
  attr_accessible :id, :event_id, :team1_nb, :team2_nb, :score, :winning_team_nb, :date
  belongs_to :event
end
