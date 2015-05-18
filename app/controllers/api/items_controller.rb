class Api::ItemsController < Api::BaseApiController
  
  def index
    
    
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Item.where{ 
        (
          (name =~  livesearch ) | 
          (code =~  livesearch )
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Item.where{ 
        (
          (name =~  livesearch ) | 
          (code =~  livesearch )
        )
      }.count
      
      # calendar
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
      @objects = Item.
                  where(:customer_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Item.where(:customer_id => params[:parent_id]).count 
    else
      @objects = []
      @total = 0 
    end
    
    
    
    
    
    # render :json => { :items => @objects , :total => @total, :success => true }
  end

  def create
    @object = Item.create_object( params[:item] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :items => [@object] , 
                        :total => Item.active_objects.count }  
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
    
    @object = Item.find_by_id params[:id] 
    @object.update_object( params[:item])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :items => [@object],
                        :total => Item.active_objects.count  } 
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
    @object = Item.find(params[:id])
    @object.delete_object

    if @object.is_deleted
      render :json => { :success => true, :total => Item.active_objects.count }  
    else
      render :json => { :success => false, :total => Item.active_objects.count }  
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
      @objects = Item.joins(:item_type).where{ 
                            (item_type.name =~ query)   | 
                            (code =~ query)  | 
                            (description =~ query)
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Item.joins(:item_type).where{ 
              (item_type.name =~ query)   | 
              (code =~ query)  | 
              (description =~ query)
                              }.count
    else
      @objects = Item.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Item.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
end
