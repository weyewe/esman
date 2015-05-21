class Api::CashMutationsController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
    @objects = CashMutation.joins(:cash_bank).where{ 
        (
          (source_class =~  livesearch ) |
          (source_code =~  livesearch ) |
          (cash_bank.name =~  livesearch ) |
          (description =~  livesearch ) 
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = CashMutation.joins(:cash_bank).where{
        (
          (code =~  livesearch ) |
          (source_code =~  livesearch ) |
          (cash_bank.name =~  livesearch ) |  
          (description =~  livesearch ) 
        )
        
      }.count
    else
      @objects = CashMutation.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = CashMutation.active_objects.count
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
      @objects = CashMutation.active_objects.joins(:cash_bank).where{
                                (                                  
                                  (code =~  query ) | 
                                  (source_code =~  query ) |
                                  (cash_bank.name =~  query ) |    
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = CashMutation.active_objects.joins(:cash_bank).where{ 
                                ( 
                                  (code =~  query ) |
                                  (source_code =~  query ) |
                                  (cash_bank.name =~  query ) |     
                                  (description =~  query ) 
                                )
                              }.count
    else
      @objects = CashMutation.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = CashMutation.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
