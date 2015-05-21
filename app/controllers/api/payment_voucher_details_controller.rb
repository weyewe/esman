class Api::PaymentVoucherDetailsController < Api::BaseApiController
  
  def index
    @parent = PaymentVoucher.find_by_id params[:payment_voucher_id]
    @objects = @parent.active_payment_voucher_details.joins(:payment_voucher).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_payment_voucher_details.count
  end

  def create
   
    @parent = PaymentVoucher.find_by_id params[:payment_voucher_id]
    
  
    @object = PaymentVoucherDetail.create_object(params[:payment_voucher_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :payment_voucher_details => [@object] , 
                        :total => @parent.active_payment_voucher_details.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg                         
    end
  end

  def update
    @object = PaymentVoucherDetail.find_by_id params[:id] 
    @parent = @object.payment_voucher 
    
    
    params[:payment_voucher_detail][:payment_voucher_id] = @parent.id  
    
    @object.update_object( params[:payment_voucher_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :payment_voucher_details => [@object],
                        :total => @parent.active_payment_voucher_details.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end

  def destroy
    @object = PaymentVoucherDetail.find(params[:id])
    @parent = @object.payment_voucher 
    @object.delete_object 

    if  not @object.persisted? 
      render :json => { :success => true, :total => @parent.active_payment_voucher_details.count }  
    else
      render :json => { :success => false, :total =>@parent.active_payment_voucher_details.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
            }  
    end
  end
 
  
 
end
