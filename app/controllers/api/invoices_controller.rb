class Api::InvoicesController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
    @objects = Invoice.joins(:home).where{ 
        (
          (source_class =~  livesearch ) |      
          (home.name =~  livesearch ) |
          (description =~  livesearch ) 
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
    @total = Invoice.joins(:home).where{
        (
          (code =~  livesearch ) |
          (home.name =~  livesearch ) | 
          (description =~  livesearch ) 
        )
        
      }.count
    else
      @objects = Invoice.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Invoice.active_objects.count
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
      @objects = Invoice.active_objects.joins(:home).where{
                                (                                  
                                  (code =~  query ) |                               
                                  (home.name =~  query ) |    
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Invoice.active_objects.joins(:home).where{ 
                                ( 
                                  (code =~  query ) |
                                  (home.name =~  query ) |     
                                  (description =~  query ) 
                                )
                              }.count
    else
      @objects = Invoice.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Invoice.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
