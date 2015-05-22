class PaymentRequest < ActiveRecord::Base
  has_many :vendor
  validates_presence_of :vendor_id
  validates_presence_of :request_date
  validates_presence_of :amount
   
  
  validate :valid_vendor
  validate :valid_amount
  
  
  
  def self.active_objects
    self.where{
      (is_deleted.eq false)
      }
  end
  
  def valid_vendor
    return if vendor_id.nil? 
    vendor = Vendor.find_by_id(vendor_id)
    if vendor.nil?
      self.errors.add(:vendor_id, "Harus ada vendor Id")
      return self
    end
  end
  
  
  def valid_amount
    return if amount.nil?   
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end       
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.vendor_id = params[:vendor_id]
    new_object.request_date = params[:request_date]
    new_object.amount = params[:amount]
    new_object.description = params[:description]
    new_object.save
    new_object.code = "Pr-" + new_object.id.to_s  
    new_object.save
    return new_object
  end
  
  def update_object( params ) 
    
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    self.vendor_id = params[:vendor_id]
    self.request_date = params[:request_date]
    self.amount = params[:amount]
    self.description = params[:description]
    self.save
    return self
  end
   
  
  def generate_payable
    Payable.create_object(
      :source_id => self.id,
      :source_class => self.class.to_s,
      :source_code => self.code,
      :amount => self.amount,
      :remaining_amount =>self.amount
      )
  end
  
  def delete_payable
    rvl = Payable.where(
      :source_id =>self.id,
      :source_class => self.class.to_s, 
      :is_deleted =>false
      )
    rvl.each do |x|
     x.delete_object
    end
  end

  
  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    self.generate_payable if self.save  
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    prclass = self.class.to_s
    prid = self.id
    payment_voucher_count = PaymentVoucherDetail.joins(:payable).where{
      (
        (payable.source_class.eq prclass) &
        (payable.source_id.eq prid) &
        (is_deleted.eq false)
      )
      }.count
    if payment_voucher_count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di PaymentVoucher")
      return self
    end
    self.is_confirmed = false
    self.confirmed_at = nil
    if self.save
      self.delete_payable
    end
  end
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
 
    self.is_deleted = true
    self.deleted_at = DateTime.now
    self.save
    return self
  end
  
end
