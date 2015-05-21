class PaymentVoucher < ActiveRecord::Base
  validates_presence_of :payment_date
  validate :valid_cash_bank
  validate :valid_vendor
  belongs_to :vendor
  belongs_to :cash_bank
  has_many :payment_voucher_details
  
  
  def self.active_objects
    self.where(:is_deleted => false)
  end
  
  def  active_payment_voucher_details
    self.payment_voucher_details
  end
  
  def valid_vendor
    return if  vendor_id.nil?
    cb = Vendor.find_by_id vendor_id
    
    if cb.nil? 
      self.errors.add(:vendor_id, "Harus ada vendor id")
      return self 
    end
  end 
  
  def valid_cash_bank
    return if  cash_bank_id.nil?
    cb = CashBank.find_by_id cash_bank_id
    
    if cb.nil? 
      self.errors.add(:cash_bank_id, "Harus ada CashBank id")
      return self 
    end
  end 
  
  def self.create_object(params)
    new_object = self.new
    new_object.description = params[:description]
    new_object.payment_date = params[:payment_date]
    new_object.vendor_id = params[:vendor_id]
    new_object.cash_bank_id = params[:cash_bank_id]
    new_object.amount = BigDecimal("0")
    new_object.save
    if new_object.save
      new_object.code = "Pv-" + new_object.id.to_s
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    if self.payment_voucher_details.where(:is_deleted => false).count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end 
    
    self.description = params[:description]
    self.payment_date = params[:payment_date]
    self.cash_bank_id = params[:cash_bank_id]
    self.vendor_id = params[:vendor_id]
    self.save
    return self
  end
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    if self.payment_voucher_details.where(:is_deleted => false).count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end 
    self.is_deleted = true
    self.deleted_at = DateTime.now
    self.save
    return self
  end
  
  def update_cash_bank_amount(amount)
    cb = CashBank.find_by_id(self.cash_bank_id)
    cb.update_amount(amount)
  end
  
  def update_payable_remaining_amount(payable_id,amount)
    rv = Payable.find_by_id(payable_id)
    rv.update_remaining_amount(amount)
  end
  
  def generate_cash_mutation(pvd)
      CashMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :source_code => self.code,
        :amount => pvd.amount ,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.confirmed_at ,  
        :cash_bank_id => self.cash_bank_id 
       ) 
  end
  
  def delete_cash_mutation
     CashMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id 
      ).each {|x| x.delete_object  }
  end
  
  def update_amount(amount)
    self.amount = amount
    self.save
  end
  
  def confirm_detail
    self.payment_voucher_details.where(:is_deleted == false).each do |pvd|
      self.update_payable_remaining_amount(pvd.payable_id,-1 * pvd.amount)
      self.generate_cash_mutation(pvd)
    end
  end
  
  def unconfirm_detail
     self.payment_voucher_details.where(:is_deleted == false).each do |pvd|        
     self.update_payable_remaining_amount(pvd.payable_id,pvd.amount)
     self.delete_cash_mutation()
    end
  end
  
  def confirm_object(params)
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    if self.payment_voucher_details.where(:is_deleted => false).count == 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end 
    if self.amount > self.cash_bank.amount 
      self.errors.add(:generic_errors, "Dana tidak mencukupi")
      return self 
    end
    
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save
      self.confirm_detail
      self.update_cash_bank_amount(-1 *self.amount)
    end
    return self
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    self.is_confirmed = false
    self.confirmed_at = nil
     if self.save
      self.unconfirm_detail
      self.update_cash_bank_amount(self.amount)
    end
    return self
  end
end
