class CashBankMutation < ActiveRecord::Base
  validates_presence_of :target_cash_bank_id
  validates_presence_of :source_cash_bank_id
  validates_presence_of :mutation_date
  validates_presence_of :amount
  
  validate :valid_target_and_source
  validate :valid_amount
  
  
  def self.active_objects
    self.where(:is_deleted => false)
  end
  
  def valid_target_and_source
    return if target_cash_bank_id.nil? or source_cash_bank_id.nil?
    
    if target_cash_bank_id == source_cash_bank_id 
      self.errors.add(:target_cash_bank_id, "Tidak boleh sama dengan source cashbank")
      return self
    end
    
    target_cash_bank = CashBank.find_by_id(target_cash_bank_id)
    source_cash_bank = CashBank.find_by_id(source_cash_bank_id)
    
    if target_cash_bank.nil? 
      self.errors.add(:target_cash_bank_id, "Harus ada target cashbank id")
      return self
    end
    
    if source_cash_bank.nil? 
      self.errors.add(:source_cash_bank_id, "Harus ada source cashbank id")
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
    new_object.target_cash_bank_id = params[:target_cash_bank_id]
    new_object.source_cash_bank_id = params[:source_cash_bank_id]
    new_object.amount =  BigDecimal( params[:amount] || '0')
    new_object.description = params[:description]
    new_object.mutation_date = params[:mutation_date]   
    new_object.save
    new_object.code = "Cmt-" + new_object.id.to_s  
    new_object.save
    
    return new_object
  end
   
  def update_object(params) 
    if self.is_confirmed?
      self.errors.add(:generic_errors,"Sudah dikonfirmasi")
      return self
    end
    self.target_cash_bank_id = params[:target_cash_bank_id]
    self.source_cash_bank_id = params[:source_cash_bank_id]
    self.amount =  BigDecimal( params[:amount] || '0')
    self.description = params[:description]
    self.mutation_date = params[:mutation_date]
   
    
    new_object.save
    return self
  end
  
  def target_cash_bank
    CashBank.find_by_id(self.target_cash_bank_id)
  end
  
  def source_cash_bank
    CashBank.find_by_id(self.source_cash_bank_id) 
  end
  
  
  
  def confirm_object(params)
    if self.is_confirmed?
      self.errors.add(:generic_errors,"Sudah dikonfirmasi")
      return self
    end
    
    if self.amount > source_cash_bank.amount 
      self.errors.add(:generic_errors,"Tidak Cukup Dana")
      return self
    end
    
    if params[:confirmed_at].nil? 
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end
    
    
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true
    if self.save
      #       update target cashbank  
      target_cash_bank.update_amount( self.amount )
      #       update source cashbank 
      source_cash_bank.update_amount( -1 * self.amount )
      
      #       create cash mutation for sourcecashbank
      CashMutation.create_object(
        :source_class => self.class.to_s,
        :source_id => self.id,
        :amount => self.amount,
        :status =>  ADJUSTMENT_STATUS[:addition],
        :mutation_date => self.mutation_date,
        :cash_bank_id => self.target_cash_bank_id ,
        :source_code => self.code
        )
      
     #       create cash mutation for targetcashbank
      CashMutation.create_object(
        :source_class => self.class.to_s,
        :source_id => self.id,
        :amount => self.amount,
        :status =>  ADJUSTMENT_STATUS[:deduction],
        :mutation_date => self.mutation_date,
        :cash_bank_id => self.source_cash_bank_id ,
        :source_code => self.code
        )
  
    end
  end
  
  
  def destroy_cash_mutation
     CashMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id 
      ).each {|x| x.delete_object  }
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors,"Belum di konfirmasi")
      return self
    end
    
    if target_cash_bank.amount < self.amount
      self.errors.add(:generic_errors,"Jumlah dana pada target cash bank tidak mencukupi")
      return self
    end
    
    self.confirmed_at = nil
    self.is_confirmed = false
    if self.save
       #       update target cashbank  
      target_cash_bank.update_amount( -1 * self.amount )
      #       update source cashbank 
      source_cash_bank.update_amount(self.amount )
      
      self.destroy_cash_mutation    
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
  end
end
