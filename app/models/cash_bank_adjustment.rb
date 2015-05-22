class CashBankAdjustment < ActiveRecord::Base
  belongs_to :cash_bank
  
  validates_presence_of :cash_bank_id
  validates_presence_of :adjustment_date
  validates_presence_of :status
  validates_presence_of :amount
  
  validate :valid_cash_bank
  validate :valid_adjustment_status
  validate :valid_amount
  
  def self.active_objects
    self.where(:is_deleted => false)
  end
  
  def valid_cash_bank
    return if  cash_bank_id.nil?
    
    cb = CashBank.find_by_id cash_bank_id
    
    if cb.nil? 
      self.errors.add(:cash_bank_id, "Harus ada cashbank id")
      return self 
    end
  end
  
  def valid_adjustment_status
    return if status.nil? 
    
    if not  [
      ADJUSTMENT_STATUS[:addition],
      ADJUSTMENT_STATUS[:deduction]
      ].include?( status.to_i )
      self.errors.add(:status, "Harus memilih status")
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
  
  
  
  def self.create_object( params )
    new_object = self.new
    new_object.cash_bank_id = params[:cash_bank_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.status = params[:status]
    new_object.adjustment_date = params[:adjustment_date]
    new_object.description = params[:description]
    new_object.save
    new_object.code = "Cadj-" + new_object.id.to_s  
    new_object.save
    
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    self.cash_bank_id = params[:cash_bank_id]
    self.amount = BigDecimal( params[:amount] || '0')
    self.status = params[:status]
    self.adjustment_date = params[:adjustment_date]
    self.description = params[:description]
    self.code = params[:code]
    
    self.save 
    
    return self
  end
  
  def confirm_object( params )
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.status == ADJUSTMENT_STATUS[:deduction] and self.amount > cash_bank.amount 
      self.errors.add(:generic_errors, "Jumlah final di cashbank tidak boleh negative")
      return self 
    end
    
#     if params[:confirmed_at].nil? or not params[:confirmed_at].is_a?(DateTime)
#       self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
#       return self 
#     end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end
    
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true 
    
    if self.save 
      #       update cashbank 
      multiplier = 1 
      multiplier = -1 if self.status == ADJUSTMENT_STATUS[:deduction]
      cash_bank.update_amount( multiplier* amount )
      
      self.generate_cash_mutation  
    end
    
    return self 
  end
  
  def generate_cash_mutation
    CashMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => self.amount ,  
        :status => self.status,  
        :mutation_date => self.adjustment_date ,  
        :cash_bank_id => self.cash_bank_id ,
        :source_code => self.code
       ) 
  end
  
  def destroy_cash_mutation
    CashMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id
      ).each {|x| x.delete_object  }
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    
    if self.status == ADJUSTMENT_STATUS[:addition] and self.amount > cash_bank.amount 
      self.errors.add(:generic_errors, "Jumlah final di cashbank tidak boleh negative")
      return self 
    end
    
    self.is_confirmed = false
    self.confirmed_at = nil 
    if self.save
      multiplier = 1 
      multiplier = -1 if self.status == ADJUSTMENT_STATUS[:addition]
      cash_bank.update_amount( multiplier* amount ) 
      
      self.destroy_cash_mutation 
    end
    
    return self
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
