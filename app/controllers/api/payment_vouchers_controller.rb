class Api::PaymentVouchersController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = PaymentVoucher.active_objects.where{
         (is_deleted.eq false ) & 
         (
            (code =~ livesearch)  |
            (vendor.name =~ livesearch) |
            (cash_bank.name =~ livesearch) |
            (description =~ livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = PaymentVoucher.active_objects.where{
         (is_deleted.eq false ) & 
         (
           (code =~ livesearch)  |
           (vendor.name =~ livesearch) |
           (cash_bank.name =~ livesearch) |
           (description =~ livesearch)
         )
       }.count
 

     else
       @objects = PaymentVoucher.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = PaymentVoucher.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:payment_voucher][:payment_date] =  parse_date( params[:payment_voucher][:payment_date] )
    
    
    @object = PaymentVoucher.create_object( params[:payment_voucher])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :payment_vouchers => [
                          :id => @object.id, 
                          :code => @object.code,
                          :cash_bank_id => @object.cash_bank_id,
                          :cash_bank_name => @object.cash_bank.name,
                          :vendor_id => @object.vendor_id,
                          :vendor_name => @object.vendor.name,
                          :amount => @object.amount,
                          :description => @object.description ,
                          :payment_date => format_date_friendly(@object.payment_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => PaymentVoucher.active_objects.count }  
    else
      puts "It is fucking error!!\n"*10
      @object.errors.messages.each {|x| puts x }
      
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors ) 
          # :errors => {
          #   :name => "Nama tidak boleh bombastic"
          # }
        }
      }
      
      render :json => msg                         
    end
  end
  
  def show
    @object  = PaymentVoucher.find params[:id]
    render :json => { :success => true,   
                      :payment_vouchers => [
                          :id => @object.id, 
                          :code => @object.code,
                          :cash_bank_id => @object.cash_bank_id,
                          :cash_bank_name => @object.cash_bank.name,
                          :vendor_id => @object.vendor_id,
                          :vendor_name => @object.vendor.name,
                          :amount => @object.amount,
                          :description => @object.description ,
                          :payment_date => format_date_friendly(@object.payment_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                        
                        ],
                      :total => PaymentVoucher.active_objects.count  }
  end

  def update
    params[:payment_voucher][:payment_date] =  parse_date( params[:payment_voucher][:payment_date] )
    params[:payment_voucher][:confirmed_at] =  parse_date( params[:payment_voucher][:confirmed_at] )
    
    @object = PaymentVoucher.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :payment_vouchers, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:payment_voucher][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :payment_vouchers, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unconfirm_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
    else
      @object.update_object(params[:payment_voucher])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :payment_vouchers => [
                            :id => @object.id,
                            :code => @object.code,
                            :cash_bank_id => @object.cash_bank_id,
                            :cash_bank_name => @object.cash_bank.name,
                            :vendor_id => @object.vendor_id,
                            :vendor_name => @object.vendor.name,
                            :amount => @object.amount,
                            :description => @object.description ,
                            :payment_date => format_date_friendly(@object.payment_date)  ,
                            :is_confirmed => @object.is_confirmed,
                            :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ],
                        :total => PaymentVoucher.active_objects.count  } 
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
    @object = PaymentVoucher.find(params[:id])
    @object.delete_object

    if (( not @object.persisted? )   or @object.is_deleted ) and @object.errors.size == 0
      render :json => { :success => true, :total => PaymentVoucher.active_objects.count }  
    else
      render :json => { :success => false, :total => PaymentVoucher.active_objects.count, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        } 
      }  
    end
  end
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?  
      @objects = PaymentVoucher.joins(:vendor,:cash_bank).where{  
                              (code =~ query)  |
                              (vendor.name =~ query) |
                              (cash_bank.name =~ query) |
                              (description =~ query)
        
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    else
      @objects = PaymentVoucher.where{ (id.eq selected_id)  & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    end
    
    
    render :json => { :records => @objects , :total => @objects.count, :success => true }
  end
end
