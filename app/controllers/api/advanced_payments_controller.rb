class Api::AdvancedPaymentsController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
    @objects = AdvancedPayment.joins(:home).where{ 
        (
          (home.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = AdvancedPayment.joins(:home).where{
        (
          (home.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
        )
        
      }.count
    else
      @objects = AdvancedPayment.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = AdvancedPayment.active_objects.count
    end
    
    
    
    # render :json => { :advanced_payments => @objects , :total => @total, :success => true }
  end

  def create
    @object = AdvancedPayment.create_object( params[:advanced_payment] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :advanced_payments => [@object] , 
                        :total => AdvancedPayment.active_objects.count }  
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
    @object = AdvancedPayment.find_by_id params[:id] 
    if params[:confirm].present?
      if not current_user.has_role?( :advanced_payments, :confirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.confirm_object(params[:advanced_payment]) 
      
      elsif params[:unconfirm].present?
        if not current_user.has_role?( :advanced_payments, :unconfirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.unconfirm_object
      
    else
      @object.update_object( params[:advanced_payment])
    end
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :advanced_payments => [@object],
                        :total => AdvancedPayment.active_objects.count  } 
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
    @object = AdvancedPayment.find(params[:id])
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
      
      
      render :json => { :success => true, :total => AdvancedPayment.active_objects.count }  
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
      @objects = AdvancedPayment.active_objects.joins(:home).where{
                                (
                                  (home.name =~  query ) | 
                                  (code =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = AdvancedPayment.active_objects.joins(:home).where{ 
                                (
                                  (home.name =~  query ) | 
                                  (code =~  query ) |
                                  (description =~  query ) 
                                )
                              }.count
    else
      @objects = AdvancedPayment.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = AdvancedPayment.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
