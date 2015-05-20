class Invoice < ActiveRecord::Base

  def self.create_object (params)
     new_object = self.new
     new_object.source_id = params[:source_id]
     new_object.source_class = params[:source_class]
     new_object.home_id = params[:home_id]
     new_object.amount = BigDecimal( params[:amount] || '0')
     new_object.due_date = params[:due_date]
     new_object.invoice_date = params[:invoice_date]
     new_object.description = params[:description]
     new_object.is_confirmed = params[:is_confirmed]
     new_object.confirmed_at = params[:confirmed_at]
     new_object.save
     new_object.code = "Inv-" + new_object.id.to_s  
     new_object.save
     return new_object
  end
  
  def update_object (params)
     self.source_id = params[:source_id]
     self.source_class = params[:source_class]
     self.home_id = params[:home_id]
     self.amount =  BigDecimal( params[:amount] || '0')
     self.due_date = params[:due_date]
     self.invoice_date = params[:invoice_date]
     self.description = params[:description]
     return self
  end
  
  def delete_object
    self.is_deleted = true
    self.deleted_at = DateTime.now
    self.save
    return self
  end  
  
  def generate_receivable
    Receivable.create_object(
      :source_class => self.class.to_s,
      :source_id => self.id,
      :source_code => self.code,
      :amount =>  self.amount,
      :remaining_amount => self.amount
      )
  end
  
  def confirm_object (params)
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    self.generate_receivable if self.save  
  end
    
  
end
