class Api::DepositDocumentsController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
    @objects = DepositDocument.joins(:user,:home).where{ 
        (
          (user.name =~  livesearch ) |
          (home.name =~  livesearch ) |
          (code =~  livesearch ) |
          (description =~  livesearch ) 
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = DepositDocument.joins(:user,:home).where{
        (
          (user.name =~  livesearch ) |
          (home.name =~  livesearch ) |
          (code =~  livesearch ) |
          (description =~  livesearch ) 
        )
        
      }.count
    else
      @objects = DepositDocument.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = DepositDocument.active_objects.count
    end
    
    
    
    # render :json => { :deposit_documents => @objects , :total => @total, :success => true }
  end

  def create
    @object = DepositDocument.create_object( params[:deposit_document] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :deposit_documents => [@object] , 
                        :total => DepositDocument.active_objects.count }  
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
    @object = DepositDocument.find_by_id params[:id] 
    if params[:confirm].present?
      if not current_user.has_role?( :deposit_documents, :confirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.confirm_object(params[:deposit_document]) 
      
      elsif params[:unconfirm].present?
        if not current_user.has_role?( :deposit_documents, :unconfirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.unconfirm_object
      elsif params[:finish].present?
        if not current_user.has_role?( :deposit_documents, :unconfirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.finish_object(params[:deposit_document]) 
      elsif params[:unfinish].present?
        if not current_user.has_role?( :deposit_documents, :unconfirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.unfinish_object
      
    else
      @object.update_object( params[:deposit_document])
    end
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :deposit_documents => [@object],
                        :total => DepositDocument.active_objects.count  } 
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
    @object = DepositDocument.find(params[:id])
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
      
      
      render :json => { :success => true, :total => DepositDocument.active_objects.count }  
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
      @objects = DepositDocument.active_objects.joins(:user,:home).where{
                                (      
                                  (user.name =~  query ) |
                                  (home.name =~  query ) |
                                  (code =~  query ) |
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = DepositDocument.active_objects.joins(:user,:home).where{ 
                                ( 
                                  (user.name =~  query ) |
                                  (home.name =~  query ) |
                                  (code =~  query ) |
                                  (description =~  query )
                                )
                              }.count
    else
      @objects = DepositDocument.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = DepositDocument.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
