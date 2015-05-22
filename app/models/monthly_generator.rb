class MonthlyGenerator < ActiveRecord::Base
  validates_presence_of :generated_date 
  
  def self.active_objects
  self.where{
      (is_deleted.eq false) 
      }
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.generated_date = params[:generated_date]
    new_object.description = params[:description]
    new_object.save
    new_object.code = "Mg-" + new_object.id.to_s  
    new_object.save
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    self.generated_date = params[:generated_date]
    self.description = params[:description]
    self.save
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
  
  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    self.generate_invoice if self.save
    return self
  end
  
  def validate_invoice_used_at_receipt_voucher
    
  end
  
  def unconfirm_object
    if not self.is_confirmed? 
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self
    end   
    rvl = Invoice.where(
        :source_id => self.id,
        :source_class => self.class.to_s, 
        :is_deleted =>false
        )
    rvl.each do |x|  
      invclass = x.class.to_s
      invid = x.id
      rv_count = ReceiptVoucher.joins(:receivable).where{
        (
          (receivable.source_class.eq invclass) &
          (receivable.source_id.eq invid) &
          (is_deleted.eq false)
        )
      }.count
      if rv_count > 0
        self.errors.add(:generic_errors, "Sudah di buat ReceiptVoucher")
        return self
      end
    end
        
    self.is_confirmed = false
    self.confirmed_at = nil
    self.delete_invoice if self.save
    return self
  end
  
  def delete_invoice
    rvl = Invoice.where(
      :source_id => self.id,
      :source_class => self.class.to_s, 
      :is_deleted =>false
      )
    rvl.each do |x|
     x.unconfirm_object
     x.delete_object
    end
  end
  
  def generate_invoice
    if not self.is_confirmed? 
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self
    end
    Home.all.each do |home|
      end_of_month = self.generated_date.end_of_month
      start_of_month = self.generated_date.beginning_of_month 
      source_class_target = self.class.to_s 
      advance_payment_class = AdvancedPayment.to_s
      if Invoice.where{
        ( invoice_date.lte end_of_month ) & 
        ( invoice_date.gt start_of_month ) & 
        ( home_id.eq home.id) & 
        (( source_class.eq source_class_target) | (source_class.eq advance_payment_class) ) &
        ( is_deleted.eq false)
        }.count == 0
        inv = Invoice.create_object(
          :source_id => self.id,
          :source_class => self.class.to_s,
          :source_code => self.code,
          :invoice_date => self.generated_date, 
          :home_id => home.id,
          :amount => home.home_type.amount,
          :description => self.description,
          :is_confirmed =>false,
        )
        inv.confirm_object(
          :confirmed_at => self.generated_date
        )
      end
    end
    
  end
  
end
