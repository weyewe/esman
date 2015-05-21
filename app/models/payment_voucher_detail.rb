class PaymentVoucherDetail < ActiveRecord::Base

  validate :valid_payable
  validate :valid_payment_voucher
  belongs_to :payable
  belongs_to :payment_voucher
  
  
  def self.active_objects
    self.where(:is_deleted => false)
  end
  
  def valid_payment_voucher
    return if  payment_voucher_id.nil?
    cb = PaymentVoucher.find_by_id payment_voucher_id
    if cb.nil? 
      self.errors.add(:payment_voucher_id, "Harus ada payment_voucher id")
      return self 
    end
  end 
  
  def valid_payable
    return if  payable_id.nil?
    cb = Payable.find_by_id payable_id
    
    if cb.nil? 
      self.errors.add(:payable_id, "Harus ada payable id")
      return self 
    end
    
    pvcount = PaymentVoucherDetail.where(
      :payment_voucher_id => payment_voucher_id,
      :is_deleted => false,
      :payable_id => cb.id
      ).count  
    
    if self.persisted?
       if pvcount > 1
         self.errors.add(:payable_id, "Payable sudah terpakai")
      return self 
       end
    else
       if pvcount > 0
         self.errors.add(:payable_id, "Payable sudah terpakai")
      return self 
       end
    end
  end 
  
  def calculateTotalAmount
    amount = 0
    PaymentVoucherDetail.where(:payment_voucher_id =>payment_voucher_id,:is_deleted => false).each do |pvd|
      amount += pvd.amount
    end
    PaymentVoucher.find_by_id(payment_voucher_id).update_amount(amount)
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.payment_voucher_id = params[:payment_voucher_id]
    new_object.payable_id = params[:payable_id]
    new_object.save
    if new_object.save
      new_object.amount = Payable.find_by_id(params[:payable_id]).amount
      new_object.save
      new_object.calculateTotalAmount
    end
    return new_object
  end
  
  def update_object(params)
    if self.payment_voucher.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.payable_id = params[:payable_id]
    if self.save
      self.amount = Payable.find_by_id(params[:payable_id]).amount
      self.save
      self.calculateTotalAmount
    end
    return self
  end
  
  def delete_object
    if self.payment_voucher.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.is_deleted = true
    self.deleted_at = DateTime.now
    self.save
    return self
  end
  
end
