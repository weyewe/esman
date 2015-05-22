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
  
  def self.active_objects
    self.where(:is_deleted => false)
  end
  
  def update_object( params ) 
    self.name = params[:name]
    self.description = params[:description]
    self.is_bank = params[:is_bank]
    self.save
    
    return self
  end
  
  def delete_object
    if CashBankAdjustment.where(:cash_bank_id => self.id,:is_deleted => false).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di CashBankAdjustment")
      return self
    end
    if CashBankMutation.where{
      ((source_cash_bank_id.eq self.id) & (is_deleted.eq false))|
      ((target_cash_bank_id.eq self.id) & (is_deleted.eq false))
      }.count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di CashBankMutation")
      return self
    end
    if ReceiptVoucher.where(:cash_bank_id => self.id,:is_deleted => false).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di ReceiptVoucher")
      return self
    end
    if PaymentVoucher.where(:cash_bank_id => self.id,:is_deleted => false).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di PaymentVoucher")
      return self
    end
    self.is_deleted = true
    self.deleted_at = DateTime.now
    return self
  end
  
  def update_amount( amount )
    self.amount += amount
    self.save 
  end
end
