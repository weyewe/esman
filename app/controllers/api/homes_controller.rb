class Api::HomesController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Home.joins(:home_type).where{ 
        (
          (name =~  livesearch ) | 
          (address =~  livesearch ) |
          (home_type.name =~ livesearch ) |
          (home_type.description =~ livesearch)
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Home.joins(:home_type).where{
        (
          (name =~  livesearch ) | 
          (address =~  livesearch ) |
          (home_type.name =~ livesearch ) |
          (home_type.description =~ livesearch)
        )
        
      }.count
    else
      @objects = Home.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Home.active_objects.count
    end
    
    
    
    # render :json => { :home_types => @objects , :total => @total, :success => true }
  end

  def create
    @object = Home.create_object( params[:home] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :homes => [@object] , 
                        :total => Home.active_objects.count }  
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
    
    @object = Home.find_by_id params[:id] 
    @object.update_object( params[:home])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :homes => [@object],
                        :total => Home.active_objects.count  } 
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
    @object = Home.find(params[:id])
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
      @objects = Home.active_objects.joins(:home_type).where{
                              (
                                (name =~  query ) | 
                                (address =~  query ) |
                                (home_type.name =~ query ) |
                                (home_type.description =~ query)
                              )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Home.active_objects.joins(:home_type).where{ 
                              (
                                (name =~  query ) | 
                                (address =~  query ) |
                                (home_type.name =~ query ) |
                                (home_type.description =~ query)
                              )
                              }.count
    else
      @objects = Home.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Home.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
