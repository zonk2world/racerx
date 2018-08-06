class Team < ActiveRecord::Base
  default_scope { order('name') } 
  has_many :riders
end
