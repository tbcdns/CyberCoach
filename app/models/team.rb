class Team < ActiveRecord::Base
 attr_accessible :id, :team_nb, :user_id, :event_id
  #belongs_to :user
  #belongs_to :event
end
