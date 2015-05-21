class Api::CashBankAdjustmentsController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
    @objects = CashBankAdjustment.joins(:cash_bank).where{ 
        (
          (cash_bank.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = CashBankAdjustment.joins(:cash_bank).where{
        (
          (cash_bank.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
        )
        
      }.count
    else
      @objects = CashBankAdjustment.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = CashBankAdjustment.active_objects.count
    end
    
    
    
    # render :json => { :cash_bank_adjustments => @objects , :total => @total, :success => true }
  end

  def create
    @object = CashBankAdjustment.create_object( params[:cash_bank_adjustment] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :cash_bank_adjustments => [@object] , 
                        :total => CashBankAdjustment.active_objects.count }  
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
    @object = CashBankAdjustment.find_by_id params[:id] 
    if params[:confirm].present?
      if not current_user.has_role?( :cash_bank_adjustments, :confirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.confirm_object(params[:cash_bank_adjustment]) 
      
      elsif params[:unconfirm].present?
        if not current_user.has_role?( :cash_bank_adjustments, :unconfirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.unconfirm_object
      
    else
      @object.update_object( params[:cash_bank_adjustment])
    end
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :cash_bank_adjustments => [@object],
                        :total => CashBankAdjustment.active_objects.count  } 
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
    @object = CashBankAdjustment.find(params[:id])
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
      
      
      render :json => { :success => true, :total => CashBankAdjustment.active_objects.count }  
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
      @objects = CashBankAdjustment.active_objects.joins(:cash_bank).where{
                                (
                                  (cash_bank.name =~  query ) | 
                                  (code =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = CashBankAdjustment.active_objects.joins(:cash_bank).where{ 
                                (
                                  (cash_bank.name =~  query ) | 
                                  (code =~  query ) |
                                  (description =~  query ) 
                                )
                              }.count
    else
      @objects = CashBankAdjustment.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = CashBankAdjustment.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
