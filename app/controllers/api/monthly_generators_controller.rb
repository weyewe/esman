class Api::MonthlyGeneratorsController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
    @objects = MonthlyGenerator.where{ 
        (       
          (code =~  livesearch ) |
          (description =~  livesearch ) 
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = MonthlyGenerator.where{
        (
          (code =~  livesearch ) |
          (description =~  livesearch ) 
        )
        
      }.count
    else
      @objects = MonthlyGenerator.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = MonthlyGenerator.active_objects.count
    end
    
    
    
    # render :json => { :monthly_generators => @objects , :total => @total, :success => true }
  end

  def create
    @object = MonthlyGenerator.create_object( params[:monthly_generator] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :monthly_generators => [@object] , 
                        :total => MonthlyGenerator.active_objects.count }  
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
    @object = MonthlyGenerator.find_by_id params[:id] 
    if params[:confirm].present?
      if not current_user.has_role?( :monthly_generators, :confirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.confirm_object(params[:monthly_generator]) 
      
      elsif params[:unconfirm].present?
        if not current_user.has_role?( :monthly_generators, :unconfirm)
          render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
          return
        end
      @object.unconfirm_object
      
    else
      @object.update_object( params[:monthly_generator])
    end
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :monthly_generators => [@object],
                        :total => MonthlyGenerator.active_objects.count  } 
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
    @object = MonthlyGenerator.find(params[:id])
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
      
      
      render :json => { :success => true, :total => MonthlyGenerator.active_objects.count }  
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
      @objects = MonthlyGenerator.active_objects.where{
                                (
                                  (code =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = MonthlyGenerator.active_objects.where{ 
                                ( 
                                  (code =~  query ) |
                                  (description =~  query ) 
                                )
                              }.count
    else
      @objects = MonthlyGenerator.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = MonthlyGenerator.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
