class Api::ReceiptVouchersController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
    @objects = ReceiptVoucher.joins(:user,:cash_bank).where{ 
        (
          (user.name =~  livesearch ) | 
          (cash_bank.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = ReceiptVoucher.joins(:user,:cash_bank).where{
        (
          (user.name =~  livesearch ) | 
          (cash_bank.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
        )
        
      }.count
    else
      @objects = ReceiptVoucher.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = ReceiptVoucher.active_objects.count
    end
    
    
    
    # render :json => { :receipt_vouchers => @objects , :total => @total, :success => true }
  end

  def create
    @object = ReceiptVoucher.create_object( params[:receipt_voucher] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :receipt_vouchers => [@object] , 
                        :total => ReceiptVoucher.active_objects.count }  
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
    @object = ReceiptVoucher.find_by_id params[:id] 
    if params[:confirm].present?
      if not current_user.has_role?( :receipt_vouchers, :confirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.confirm_object(params[:receipt_voucher]) 
      
      elsif params[:unconfirm].present?
        if not current_user.has_role?( :receipt_vouchers, :unconfirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.unconfirm_object
      
    else
      @object.update_object( params[:receipt_voucher])
    end
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :receipt_vouchers => [@object],
                        :total => ReceiptVoucher.active_objects.count  } 
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
    @object = ReceiptVoucher.find(params[:id])
    @object.delete_object

    if not @object.is_deleted?
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      
      render :json => msg
    else
      
      
      render :json => { :success => true, :total => ReceiptVoucher.active_objects.count }  
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
      @objects = ReceiptVoucher.active_objects.joins(:user,:cash_bank).where{
                                (
                                  (user.name =~  query ) | 
                                  (cash_bank.name =~  query ) | 
                                  (code =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = ReceiptVoucher.active_objects.joins(:user,:cash_bank).where{ 
                                (
                                  (user.name =~  query ) | 
                                  (cash_bank.name =~  query ) | 
                                  (code =~  query ) |
                                  (description =~  query ) 
                                )
                              }.count
    else
      @objects = ReceiptVoucher.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = ReceiptVoucher.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
