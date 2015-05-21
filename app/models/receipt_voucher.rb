class ReceiptVoucher < ActiveRecord::Base
  validates_presence_of :receipt_date
  validate :valid_receivable
  validate :valid_cash_bank
  validate :valid_user
  belongs_to :receivable
  belongs_to :cash_bank
  belongs_to :user
  
  def self.active_objects
    self.where(:is_deleted => false)
  end
  
  
  def valid_receivable
    return if  receivable_id.nil?
    cb = Receivable.find_by_id receivable_id
    
    if cb.nil? 
      self.errors.add(:receivable_id, "Harus ada receivable id")
      return self 
    end
  end 
  
  def valid_user
    return if  user_id.nil?
    cb = User.find_by_id user_id
    
    if cb.nil? 
      self.errors.add(:user_id, "Harus ada user id")
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
    new_object.receipt_date = params[:receipt_date]
    new_object.user_id = params[:user_id]
    new_object.receivable_id = params[:receivable_id]
    new_object.cash_bank_id = params[:cash_bank_id]
    new_object.save
    new_object.code = "Rv-" + new_object.id.to_s
    if new_object.save
      new_object.amount =Receivable.find_by_id(params[:receivable_id]).amount
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.description = params[:description]
    self.receipt_date = params[:receipt_date]
    self.receivable_id = params[:receivable_id]
    self.cash_bank_id = params[:cash_bank_id]
    self.user_id = params[:user_id]
    if self.save
      self.amount = Receivable.find_by_id(params[:receivable_id]).amount
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

  def update_cash_bank_amount(amount)
    cb = CashBank.find_by_id(self.cash_bank_id)
    cb.update_amount(amount)
  end
  
  def update_receivable_remaining_amount(amount)
    rv = Receivable.find_by_id(self.receivable_id)
    rv.update_remaining_amount(amount)
  end
  
  def generate_cash_mutation
      CashMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => self.amount ,  
        :status => ADJUSTMENT_STATUS[:addition],  
        :mutation_date => self.confirmed_at ,  
        :cash_bank_id => self.cash_bank_id ,
        :source_code => self.code
       ) 
  end
  
  def delete_cash_mutation
     CashMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id 
      ).each {|x| x.delete_object  }
  end
  
  def confirm_object(params)
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save
      self.update_cash_bank_amount(amount)
      self.update_receivable_remaining_amount(-1* amount)
      self.generate_cash_mutation
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
      self.update_cash_bank_amount(-1 * amount)
      self.update_receivable_remaining_amount(amount)
      self.delete_cash_mutation
    end
    return self
  end
  
end
