class Home < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :address
  validates_presence_of :home_type_id
  has_many :home_assignments
  has_many :users, :through => :home_assignments
  
  validate :valid_home_type
  
  # home.users.where(:is_deleted => false ) 
  # home.home_assignments 
  
  def valid_home_type
    return if home_type_id.nil? 

    home_type = HomeType.find_by_id(home_type_id)
    
    if home_type.nil? 
      self.errors.add(:home_type_id, "Harus ada Home Type")
      return self
    end
  
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.address = params[:address]
    new_object.home_type_id = params[:home_type_id]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.address = params[:address]
    self.home_type_id = params[:home_type_id]
    self.save
    return self
  end
  
  def delete_object(params)
    self.destroy
  end

end
