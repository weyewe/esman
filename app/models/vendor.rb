class Vendor < ActiveRecord::Base
  validates_presence_of :name 
  
  has_many :payment_requests
  has_many :payment_vouchers

  
  # home.users.where(:is_deleted => false ) 
  # home.home_assignments 
 
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.address = params[:address]
    new_object.description = params[:description]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.address = params[:address]
    self.description = params[:description]
    self.save
    return self
  end
  
  def delete_object()
    self.destroy
  end
end
