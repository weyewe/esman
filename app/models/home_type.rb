class HomeType < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :description
  validate :valid_amount
  belongs_to :home
  
  def valid_amount
    return if amount.nil?
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name] 
    new_object.description = params[:description]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.description = params[:description]
    self.amount = BigDecimal( params[:amount] || '0')
    self.save
    return self
  end
  
  def delete_object
    if Home.where(:home_type_id => self.id,:is_deleted => false).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di Home")
      return self
    end
    self.is_deleted = true
    self.deleted_at = DateTime.now
    self.save
    return self
  end
end
