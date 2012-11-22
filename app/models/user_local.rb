class User_local < ActiveRecord::Base
  attr_accessible :id, :name, :password
  self.table_name = 'users'
end