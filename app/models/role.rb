class Role < ActiveRecord::Base
  acts_as_role
  attr_accessible :name, :title, :description, :the_role 
end
