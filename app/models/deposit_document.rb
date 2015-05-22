class DepositDocument < ActiveRecord::Base
  belongs_to :user
  belongs_to :home
  
  validates_presence_of :user_id
  validates_presence_of :home_id
  validates_presence_of :deposit_date
  validates_presence_of :amount_deposit
   
  
  validate :valid_user
  validate :valid_home
  validate :valid_amount_deposit
  
  def self.active_objects
    self.where{
      (is_deleted.eq false)
      }
  end
  
  def valid_home
    return if home_id.nil? 
    home = Home.find_by_id(home_id)    
    if home.nil? 
      self.errors.add(:home_id, "Harus ada Home")
      return self
    end
  end
  
  def valid_user
    return if user_id.nil? 
    user = User.find_by_id(user_id)    
    if user.nil? 
      self.errors.add(:user_id, "Harus ada User")
      return self
    end
  end      
  
  def valid_amount_deposit
    return if amount_deposit.nil?   
    if amount_deposit <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end       
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.user_id = params[:user_id]
    new_object.home_id = params[:home_id]
    new_object.deposit_date = params[:deposit_date]
    new_object.amount_deposit = params[:amount_deposit]
    new_object.description = params[:description]
    new_object.save
    new_object.code = "Dp-" + new_object.id.to_s  
    new_object.save
    return new_object
  end
  
  def update_object( params ) 
    
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    self.user_id = params[:user_id]
    self.home_id = params[:home_id]
    self.deposit_date = params[:deposit_date]
    self.amount_deposit = params[:amount_deposit]
    self.description = params[:description]
    self.save
    return self
  end
   
  
  
  def generate_receivable  
    Receivable.create_object(
      :source_id => self.id,
      :source_class => self.class.to_s,
      :source_code => self.code,
      :amount => self.amount_deposit,
      :remaining_amount =>self.amount_deposit
      )
  end
  
  def delete_receivable
    rvl = Receivable.where(
      :source_id =>self.id,
      :source_class => self.class.to_s, 
      :is_deleted =>false
      )
    rvl.each do |x|
     x.delete_object
    end
  end
      
  def generate_payable
    amount = self.amount_deposit - self.amount_charge
    if amount > BigDecimal("0")
    Payable.create_object(
      :source_id => self.id,
      :source_class => self.class.to_s,
      :source_code => self.code,
      :amount => amount,
      :remaining_amount =>amount
      )
    end
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
    self.generate_receivable if self.save  
  end
  
  def unconfirm_object
    if self.is_finished?
      self.errors.add(:generic_errors, "Sudah Selesai")
      return self
    end
    
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    
    rvclass = self.class.to_s
    rvid = self.id
    rv_count = ReceiptVoucher.joins(:receivable).where{
      (
        (receivable.source_class.eq rvclass) &
        (receivable.source_id.eq rvid) &
        (is_deleted.eq false)
      )
      }.count
    if rv_count > 0
      self.errors.add(:generic_errors, "Sudah di buat ReceiptVoucher")
      return self 
    end
    
    self.is_confirmed = false
    self.confirmed_at = nil
    self.delete_receivable if self.save
  end
  
  def finish_object(params)
    if not self.is_confirmed? 
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self
    end
    
    if self.is_finished?
      self.errors.add(:generic_errors, "Sudah selesai")
      return self
    end
    
    if self.amount_deposit < BigDecimal(params[:amount_charge])
      self.errors.add(:amount_charge, "Tidak Boleh melebihi Amount Deposit")
      return self
    end
    
    self.is_finished = true
    self.finished_at = params[:confirmed_at]
    self.amount_charge = params[:amount_charge]
    self.generate_payable if self.save  
  end
  
  def unfinish_object
    if not self.is_finished?
      self.errors.add(:generic_errors, "belum selesai")
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
    
    self.is_finished = false
    self.finished_at = nil
    self.amount_charge = BigDecimal("0")
    self.delete_payable if self.save 
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
