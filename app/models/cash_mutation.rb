class CashMutation < ActiveRecord::Base
  belongs_to :cash_bank
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new 
    new_object.source_class = params[:source_class]
    new_object.source_id = params[:source_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.status = params[:status]
    new_object.mutation_date = params[:mutation_date]
    new_object.cash_bank_id = params[:cash_bank_id] 
    new_object.source_code = params[:source_code]
    new_object.save 
    return self 
  end
   
  
  def delete_object
    self.destroy
  end
end
