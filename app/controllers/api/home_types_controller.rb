class Api::HomeTypesController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = HomeType.where{ 
        (
          (name =~  livesearch ) | 
          (address =~  livesearch ) 
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = HomeType.where{
        (
          (name =~  livesearch ) | 
          (description =~  livesearch ) 
        )
        
      }.count
    else
      @objects = HomeType.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = HomeType.active_objects.count
    end
    
    
    
    # render :json => { :home_types => @objects , :total => @total, :success => true }
  end

  def create
    @object = HomeType.create_object( params[:home_type] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :home_types => [@object] , 
                        :total => HomeType.active_objects.count }  
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
    
    @object = HomeType.find_by_id params[:id] 
    @object.update_object( params[:home_type])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :home_types => [@object],
                        :total => HomeType.active_objects.count  } 
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
    @object = HomeType.find(params[:id])
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
      @objects = HomeType.active_objects.where{
                                (
                                  (name =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = HomeType.active_objects.where{ 
                                (
                                  (name =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.count
    else
      @objects = HomeType.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = HomeType.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
