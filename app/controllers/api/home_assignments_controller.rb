class Api::HomeAssignmentsController < Api::BaseApiController
  
  def index
    
    
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Home.where{ 
        (
          (name =~  livesearch ) | 
          (address =~  livesearch ) 
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Home.where{ 
        (
          (name =~  livesearch ) | 
          (code =~  livesearch )
        )
      }.count
      
      # calendar
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
#     HomeAssignment.joins(:user => [:invoices])
    @objects = HomeAssignment.joins(:user, :home).
                  where(:home_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
    @total = HomeAssignment.joins(:user, :home).where(:home_id => params[:parent_id]).count 
    else
      @objects = []
      @total = 0 
    end
    
    
    
    
    
    # render :json => { :homeassignments => @objects , :total => @total, :success => true }
  end

  def create
    @object = HomeAssignment.create_object( params[:home_assignment] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :home_assignments => [@object] , 
                        :total => HomeAssignment.active_objects.count }  
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
    
    @object = HomeAssignment.find_by_id params[:id] 
    @object.update_object( params[:home_assignment])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :home_assignments => [@object],
                        :total => HomeAssignment.active_objects.count  } 
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
    @object = HomeAssignment.find(params[:id])
    @object.delete_object

    if @object.is_deleted
      render :json => { :success => true, :total => HomeAssignment.active_objects.count }  
    else
      render :json => { :success => false, :total => HomeAssignment.active_objects.count }  
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
      @objects = HomeAssignment.joins(:home,:user).where{ 
                            (home.name =~ query)   | 
                            (user.name =~ query)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = HomeAssignment.joins(:home,:user).where{ 
                              (home.name =~ query)   | 
                              (user.name =~ query)
                              }.count
    else
      @objects = HomeAssignment.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = HomeAssignment.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
end
