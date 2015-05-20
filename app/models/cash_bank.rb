class CashBank < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  
  has_many :cash_bank_adjustments
  
  belongs_to :receipt_voucher
  def self.create_object( params )
    new_object  = self.new
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.is_bank = params[:is_bank]
    new_object.save
    
    return new_object
  end
  
  def update_object( params ) 
    self.name = params[:name]
    self.description = params[:description]
    self.is_bank = params[:is_bank]
    self.save
    
    return self
  end
  
  def delete_object
  end
  
  def update_amount( amount )
    self.amount += amount
    self.save 
  end
end
