class Home < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :address
  validates_presence_of :home_type_id
  belongs_to :home_type 
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
  
  def self.active_objects
    self.where(:is_deleted => false)
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
  
  def delete_object
    if Invoice.where(:home_id => self.id,:is_deleted => false).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di Invoice")
      return self
    end
    if AdvancedPayment.where(:home_id => self.id,:is_deleted => false).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di AdvancedPayment")
      return self
    end
    if HomeAssignment.where(:home_id => self.id,:is_deleted => false).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di HomeAsssignment")
      return self
    end
    self.is_deleted = true
    self.deleted_at = DateTime.now
    return self
  end

end
