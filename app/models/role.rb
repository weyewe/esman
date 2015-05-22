class Role < ActiveRecord::Base
  include TheRole::Api::Role
  attr_accessible :name, :title, :description, :the_role 

  def _jsonable val
    val.is_a?(Hash) ? val : JSON.load(val)
  end

  def to_hash
    begin the_role rescue {} end
  end

  def to_json
    the_role.is_a?(Hash) ? the_role.to_json : the_role
  end
end

# class Role < ActiveRecord::Base
#   acts_as_role
#   attr_accessible :name, :title, :description, :the_role 
# end
 # include TheRole::Api::Role