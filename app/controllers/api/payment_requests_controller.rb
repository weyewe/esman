class Api::PaymentRequestsController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
    @objects = PaymentRequest.joins(:vendor).where{ 
        (
          (vendor.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = PaymentRequest.joins(:vendor).where{
        (
          (vendor.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
        )
        
      }.count
    else
      @objects = PaymentRequest.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = PaymentRequest.active_objects.count
    end
    
    
    
    # render :json => { :payment_requests => @objects , :total => @total, :success => true }
  end

  def create
    @object = PaymentRequest.create_object( params[:payment_request] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :payment_requests => [@object] , 
                        :total => PaymentRequest.active_objects.count }  
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
    @object = PaymentRequest.find_by_id params[:id] 
    if params[:confirm].present?
      if not current_user.has_role?( :payment_requests, :confirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.confirm_object(params[:payment_request]) 
      
      elsif params[:unconfirm].present?
        if not current_user.has_role?( :payment_requests, :unconfirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.unconfirm_object
      
    else
      @object.update_object( params[:payment_request])
    end
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :payment_requests => [@object],
                        :total => PaymentRequest.active_objects.count  } 
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
    @object = PaymentRequest.find(params[:id])
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
      
      
      render :json => { :success => true, :total => PaymentRequest.active_objects.count }  
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
      @objects = PaymentRequest.active_objects.joins(:vendor).where{
                                (
                                  (vendor.name =~  query ) | 
                                  (code =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = PaymentRequest.active_objects.joins(:vendor).where{ 
                                (
                                  (vendor.name =~  query ) | 
                                  (code =~  query ) |
                                  (description =~  query ) 
                                )
                              }.count
    else
      @objects = PaymentRequest.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = PaymentRequest.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
