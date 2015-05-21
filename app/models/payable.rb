class Payable < ActiveRecord::Base
  belongs_to :payment_voucher
  
  
  def self.active_objects
  self.where{
      (is_deleted.eq false)&
      (remaining_amount.gt 0)
      }
  end
  
  def self.create_object (params)
    new_object = self.new
    new_object.source_class = params[:source_class]
    new_object.source_id = params[:source_id]
    new_object.source_code = params[:source_code]
    new_object.amount =  BigDecimal( params[:amount] || '0')
    new_object.remaining_amount = params[:remaining_amount]
    new_object.save
    return new_object
  end
  
  def update_object (params)
    self.source_class = params[:source_class]
    self.source_id = params[:source_id]
    self.source_code = params[:source_code]
    self.amount = params[:amount]
    self.remaining_amount = params[:remaining_amount]
    self.save
    return self
  end
  
  def update_remaining_amount (amount)
    self.remaining_amount += amount
    self.save
    return self
  end
  
  def delete_object
    self.is_deleted = true
    self.deleted_at = DateTime.now
    self.save
    return self
  end
  
end
