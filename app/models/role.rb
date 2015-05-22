class Role < ActiveRecord::Base
  include TheRole::Api::Role
  attr_accessible :name, :title, :description, :the_role 
end

# class Role < ActiveRecord::Base
#   acts_as_role
#   attr_accessible :name, :title, :description, :the_role 
# end
