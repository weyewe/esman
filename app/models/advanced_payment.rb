class AdvancedPayment < ActiveRecord::Base
  belongs_to :home
  validates_presence_of :home_id
  validates_presence_of :start_date
  validates_presence_of :amount
  validates_presence_of :duration
   
  
  validate :valid_home
  validate :valid_amount_and_duration
  
  def self.active_objects
    self.where(:is_deleted => false)
  end
  
  def valid_home
    return if home_id.nil? 
    home = Home.find_by_id(home_id)
    if home.nil?
      self.errors.add(:home_id, "Harus ada Home Id")
      return self
    end
  end
  
  
  def valid_amount_and_duration
    return if amount.nil? or duration.nil?
    
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
    
    if duration <= 0
      self.errors.add(:duration, "Harus lebih besar dari 0")
      return self
    end
  end
  
  
  def self.create_object(params)
    new_object = self.new
    new_object.home_id = params[:home_id]
    new_object.start_date = params[:start_date]
    new_object.duration = params[:duration]
    new_object.amount = params[:amount]
    new_object.description = params[:description]
    new_object.code = params[:code]
    new_object.save
    new_object.code = "Advp-" + new_object.id.to_s  
    new_object.save
    return new_object
  end
  
  def update_object( params ) 
    
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    self.home_id = params[:home_id]
    self.start_date = params[:start_date]
    self.amount = params[:amount]
    self.duration = params[:duration]
    self.description = params[:description]
    self.save
    return self
  end
  
 
  def validate_no_invoice_in_the_period
    (0.upto self.duration-1 ).each do |month|
      end_of_month = self.start_date.end_of_month + month.months 
      start_of_month = self.start_date.beginning_of_month  + month.months 
      current_home_id = self.home_id
      invoice_count = Invoice.where{
                      ( invoice_date.lte end_of_month ) & 
                      ( invoice_date.gt start_of_month ) & 
                      ( home_id.eq current_home_id) &
                      ( is_deleted.eq false)
                      }.count

      if self.is_confirmed == true
       if invoice_count > 1
          self.errors.add(:generic_errors, "Sudah ada invoice terbuat di bulan :#{self.start_date.month}")
          return self 
        end
      else
       if invoice_count > 0 
          self.errors.add(:generic_errors, "Sudah ada invoice terbuat di bulan :#{self.start_date.month}")
        return self 
       end
      end
#       if invoice_count > 0 
#         self.errors.add(:invoice, "Sudah ada invoice terbuat di bulan :#{self.start_date.month}")
#         return self 
#        end
      
    end
  end
  
  def generate_receivable
    Receivable.create_object(
      :source_id => self.id,
      :source_class => self.class.to_s,
      :source_code => self.code,
      :amount => self.amount,
      :remaining_amount =>self.amount
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
  
  def delete_invoice
    invoice = Invoice.where(
      :source_id => self.id,
      :source_class=> self.class.to_s,
      :is_deleted =>false,
      :home_id => self.home_id) 
    invoice.each do |x|
      x.delete_object
    end
  end
  
  def generate_invoice
    (0.upto self.duration-1 ).each do |month|  
      Invoice.create_object(
        :source_id => self.id,
        :source_class => self.class.to_s,
        :source_code => self.code,
        :invoice_date => self.confirmed_at, 
        :home_id => self.home_id,
        :amount => BigDecimal(self.amount/self.duration),
        :description => self.description,
        :is_confirmed => true,
        :confirmed_at => self.confirmed_at
        )
    end 
    self.generate_receivable
  end

  
  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    self.validate_no_invoice_in_the_period
    return self if self.errors.size != 0 
    
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    self.generate_invoice if self.save  
  end
  
  def unconfirm_object
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
    if self.save
      self.delete_receivable
      self.delete_invoice
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
