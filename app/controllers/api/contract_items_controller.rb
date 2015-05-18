class Api::ContractItemsController < Api::BaseApiController
  
  def index
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = ContractItem.active_objects.where{ 
        (
          (name =~  livesearch ) | 
          (code =~  livesearch )
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = ContractItem.active_objects.where{ 
        (
          (name =~  livesearch ) | 
          (code =~  livesearch )
        )
      }.count
      
      # calendar
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
      @objects = ContractItem.active_objects.joins(:customer,:contract_maintenance, :item => [:type]).
                  where(:contract_maintenance_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = ContractItem.active_objects.where(:contract_maintenance_id => params[:parent_id]).count 
    else
      @objects = []
      @total = 0 
    end
    
    
    
    
    
    # render :json => { :contract_items => @objects , :total => @total, :success => true }
  end

  def create
    @object = ContractItem.create_object( params[:contract_item] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :contract_items => [@object] , 
                        :total => ContractItem.active_objects.count }  
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
    
    @object = ContractItem.find_by_id params[:id] 
    @object.update_object( params[:contract_item])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :contract_items => [@object],
                        :total => ContractItem.active_objects.count  } 
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
    @object = ContractItem.find(params[:id])
    @object.delete_object

    if @object.is_deleted
      render :json => { :success => true, :total => ContractItem.active_objects.count }  
    else
      render :json => { :success => false, :total => ContractItem.active_objects.count }  
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
      @objects = ContractItem.active_objects.where{ (name =~ query)   
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = ContractItem.active_objects.where{ (name =~ query)  
                              }.count
    else
      @objects = ContractItem.active_objects.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = ContractItem.active_objects.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
