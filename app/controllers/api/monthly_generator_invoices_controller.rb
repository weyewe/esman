class Api::MonthlyGeneratorInvoicesController < Api::BaseApiController
  
  def index
    
    @object = MonthlyGenerator.find_by_id params[:parent_id]
    
    @objects = Invoice.where(
      :source_id => @object.id, 
      :source_class => @object.class.to_s,
      :is_deleted => false
      ).page(params[:page]).per(params[:limit]).order("id DESC")
    
    @total = Invoice.where(
      :source_id => @object.id, 
      :source_class => @object.class.to_s,
      :is_deleted => false
      ).count
    
    
#     @parent = PaymentVoucher.find_by_id params[:payment_voucher_id]
#     @objects = @parent.active_payment_voucher_details.joins(:payment_voucher).page(params[:page]).per(params[:limit]).order("id DESC")
#     @total = @parent.active_payment_voucher_details.count
  end

  
 
end
