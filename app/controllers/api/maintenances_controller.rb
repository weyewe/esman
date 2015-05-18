class Api::MaintenancesController < Api::BaseApiController
  
  
  def build_livesearch_results
    livesearch = "%#{params[:livesearch]}%"
    @objects = Maintenance.includes(:item).active_objects.where{ 
      (
        (name =~  livesearch ) | 
        (code =~  livesearch )
      )
      
    }.page(params[:page]).per(params[:limit]).order("id DESC")
    
    @total = Maintenance.includes(:item).active_objects.where{ 
      (
        (name =~  livesearch ) | 
        (code =~  livesearch )
      )
    }.count
  end
  
  def build_personal_report_results
    view_value = params[:viewValue].to_i  
    date = parse_datetime_from_client_booking( params[:focusDate])
    date =   DateTime.new( date.year , 
                              date.month, 
                              date.day, 
                              0, 
                              0, 
                              0,
                  Rational( UTC_OFFSET , 24) )
    
    
    
                  
    customer = Customer.where(:id => params[:selectedRecordId]).first 
    if customer.nil?
      @objects  = [] 
      @total = 0 
    else
      starting_date = 0 
      ending_date = 0 
      
      if view_value == VIEW_VALUE[:week]
        starting_date = date - date.wday.days 
        ending_date = starting_date + 7.days  
      elsif view_value == VIEW_VALUE[:month]
        starting_date = date - date.mday.days 
        days_in_month = Time.days_in_month(date.month, date.year)
        ending_date = starting_date + days_in_month.days
      end
      
      current_user_id = current_user.id 
      @objects  =        Maintenance.active_objects.includes(:customer, :item).where{
        (complaint_date.gte starting_date) & 
        (complaint_date.lt ending_date ) & 
        (user_id.eq current_user_id ) & 
        (customer_id.eq customer_id.id ) & 
        (is_deleted.eq false )
      }.page(params[:page]).per(params[:limit]).order("id DESC")

    
      @total =            Maintenance.active_objects.includes(:customer, :item).where{
        (complaint_date.gte starting_date) & 
        (complaint_date.lt ending_date ) & 
        (user_id.eq current_user_id ) & 
        (customer_id.eq customer_id.id ) & 
        (is_deleted.eq false )
      }.count 
      
    end
  end
  
  def build_master_report_results # company scope 
    customer = Customer.where(:id => params[:selectedRecordId]).first 
    view_value = params[:viewValue].to_i  
    date = parse_datetime_from_client_booking( params[:focusDate])
    date =   DateTime.new( date.year , 
    date.month, 
    date.day, 
    0, 
    0, 
    0,
    Rational( UTC_OFFSET , 24) )

    if customer.nil?
      @objects  = [] 
      @total = 0 
    else

      starting_date = 0 
      ending_date = 0 

      if view_value == VIEW_VALUE[:week]
        starting_date = date - date.wday.days 
        ending_date = starting_date + 7.days  
      elsif view_value == VIEW_VALUE[:month]
        starting_date = date - date.mday.days 
        days_in_month = Time.days_in_month(date.month, date.year)
        ending_date = starting_date + days_in_month.days
      end

      if params[:parentRecordType] == 'user'
        selectedParentRecordId = params[:selectedParentRecordId].to_i
        @objects  =        Maintenance.active_objects.includes(:customer, :item).where{
          (complaint_date.gte starting_date) & 
          (complaint_date.lt ending_date ) & 
          (user_id.eq  selectedParentRecordId ) & 
          (customer_id.eq customer.id ) & 
          (is_deleted.eq false )
          }.page(params[:page]).per(params[:limit]).order("id DESC")


        @total =        Maintenance.active_objects.includes(:customer, :item).where{
          (complaint_date.gte starting_date) & 
          (complaint_date.lt ending_date ) & 
          (user_id.eq  selectedParentRecordId ) & 
          (customer_id.eq customer.id ) & 
          (is_deleted.eq false )
        }.count
      end
    end
  end


  def index
    
    
    
    if params[:livesearch].present? 
      build_livesearch_results
    elsif params[:parent_id].present?
      # @group_loan = Maintenance.find_by_id params[:parent_id]
      @objects = Maintenance.includes(:item).active_objects.
                  where(:customer_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Maintenance.includes(:item).active_objects.where(:customer_id => params[:parent_id]).count 
    elsif params[:selectedRecordId].present? and params[:viewer] == 'personal'
      build_personal_report_results # current_user scope 
    elsif params[:selectedRecordId].present? and params[:viewer] == 'master'
      if params[:companyView].present? and params[:companyView] == 'true'
        build_master_report_company_perspective_results 
      else
        build_master_report_results 
      end
    else
      @objects = []
      @total = 0 
    end
    
    
    
    
    
    # render :json => { :items => @objects , :total => @total, :success => true }
  end

  def create
    
    params[:maintenance][:complaint_date] =  parse_datetime_from_client_booking( params[:maintenance][:complaint_date] )
    params[:maintenance][:diagnosis_date] =  parse_datetime_from_client_booking( params[:maintenance][:diagnosis_date] )
    params[:maintenance][:solution_date] =  parse_datetime_from_client_booking( params[:maintenance][:solution_date] )
    
    
    @object = Maintenance.create_object( params[:maintenance] )  
    
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :maintenances => [
                          :id 							=>  	@object.id    ,
                        	:item_name 			 										 =>   @object.item.code                                ,
                        	:item_id                   => @object.item.id , 
                        	:customer_name 						 =>   @object.customer.name  ,
                        	:customer_id					 =>   @object.customer.id   ,
                        	:user_id             =>   @object.user.id , 
                        	:user_name 										 =>   @object.user.name,
                        	:complaint_date 										 =>   format_date_friendly(@object.complaint_date)    ,
                        	:complaint 							 =>   @object.complaint ,
                        	:complaint_case 									 =>    @object.complaint_case ,
                        	:complaint_case_text 											 =>   @object.complaint_case_text,
                        	:diagnosis_date 											 =>   format_date_friendly( @object.diagnosis_date )   ,
                        	:diagnosis =>   @object.diagnosis     ,
                          :diagnosis_case =>   @object.diagnosis_case,                            # 
                          :diagnosis_case_text                               => @object.diagnosis_case_text,
                          :is_diagnosed   => @object.is_diagnosed,
                          :solution_date                           =>  format_date_friendly( @object.solution_date ),
                          :solution      => @object.solution ,
                        	:solution_case => @object.solution_case,
                        	:solution_case_text => @object.solution_case_text,
                        	:is_solved => @object.is_solved,
                        	:is_confirmed => @object.is_confirmed,
                          :is_deleted => @object.is_deleted
                          ] , 
                        :total => Maintenance.active_objects.count }  
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
    @object = Maintenance.find(params[:id])
    
    
    params[:maintenance][:complaint_date] =  parse_datetime_from_client_booking( params[:maintenance][:complaint_date] )
    params[:maintenance][:diagnosis_date] =  parse_datetime_from_client_booking( params[:maintenance][:diagnosis_date] )
    params[:maintenance][:solution_date] =   parse_datetime_from_client_booking( params[:maintenance][:solution_date] )


    if params[:diagnosis].present?  
      if not current_user.has_role?( :maintenances, :diagnose)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      
      @object.diagnose(  params[:maintenance]  )
    elsif params[:solution].present?    
      
      if not current_user.has_role?( :maintenances, :undiagnose)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      @object.undiagnose 
      
    elsif params[:solve].present?
      if not current_user.has_role?( :maintenances, :solve)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      @object.solve(   params[:maintenance]  )
    elsif params[:unsolve].present?  
      if not current_user.has_role?( :maintenances, :unsolve)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
        
      @object.unsolve
    elsif params[:confirm].present?
      if not current_user.has_role?( :maintenances, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      @object.confirm 
    elsif params[:unconfirm].present?
      if not current_user.has_role?( :maintenances, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      @object.unconfirm 
    else
    
      @object.update_object(params[:maintenance])
    end
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :maintenances => [
                            :id 							=>  	@object.id    ,
                          	:item_name 			 										 =>   @object.item.code                                ,
                          	:item_id                   => @object.item.id , 
                          	:customer_name 						 =>   @object.customer.name  ,
                          	:customer_id					 =>   @object.customer.id   ,
                          	:user_id             =>   @object.user.id , 
                          	:user_name 										 =>   @object.user.name,
                          	:complaint_date 										 =>   format_date_friendly(@object.complaint_date)    ,
                          	:complaint 							 =>   @object.complaint ,
                          	:complaint_case 									 =>    @object.complaint_case ,
                          	:complaint_case_text 											 =>   @object.complaint_case_text,
                          	:diagnosis_date 											 =>   format_date_friendly( @object.diagnosis_date )   ,
                          	:diagnosis =>   @object.diagnosis     ,
                            :diagnosis_case =>   @object.diagnosis_case,                            # 
                            :diagnosis_case_text                               => @object.diagnosis_case_text,
                            :is_diagnosed   => @object.is_diagnosed,
                            :solution_date                           =>  format_date_friendly( @object.solution_date ),
                            :solution      => @object.solution ,
                          	:solution_case => @object.solution_case,
                          	:solution_case_text => @object.solution_case_text,
                          	:is_solved => @object.is_solved,
                          	:is_confirmed => @object.is_confirmed,
                            :is_deleted => @object.is_deleted
                          ],
                        :total => Maintenance.active_objects.count  } 
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
    @object = Maintenance.find(params[:id])
    @object.delete_object

    if @object.is_deleted and @object.errors.size == 0
      render :json => { :success => true, :total => Maintenance.active_objects.count }  
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
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
  
    else
      @objects = Maintenance.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Maintenance.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
  
  
=begin
  Report specific 
=end
  def reports
    render :json => {
      :component_config => {
            :title  => 'Panel dynamically loaded',
            :html => "Awesome shite",
            :xtype  => 'panel'
         }
    }
    return 
  end
  
  def prepare_params
    view_value = params[:viewValue].to_i  
    date = parse_datetime_from_client_booking( params[:focusDate])
    date =   DateTime.new( date.year , 
                              date.month, 
                              date.day, 
                              0, 
                              0, 
                              0,
                  Rational( UTC_OFFSET , 24) )
                  
     
    @starting_date = 0 
    @ending_date = 0 
    if view_value == VIEW_VALUE[:week]
      @starting_date = date - date.wday.days 
      @ending_date = @starting_date + 7.days  
      
    elsif view_value == VIEW_VALUE[:month]
      @starting_date = date - date.mday.days 
      
      days_in_month = Time.days_in_month(date.month, date.year)
      @ending_date = @starting_date + days_in_month.days
    end
     
  end
  
  def customer_reports
    prepare_params
    
    starting_date = @starting_date
    ending_date = @ending_date
    maintenances = []
    if params[:viewer] == 'personal'
      # personal view 
      if params[:parentRecordType] == 'user'
        puts "Inside viewer personal, parentType == user"
        selectedRecordId = current_user.id
        maintenances = Maintenance.active_objects.where{
          (complaint_date.gte starting_date) & 
          (complaint_date.lt ending_date ) & 
          (user_id.eq selectedRecordId )
        }
        puts "Total maintenances: #{maintenances.count}"
      end
    elsif params[:viewer] == 'master'
      puts "Inside viewer master"
      if params[:parentRecordType] == 'user'
        selectedRecordId = params[:selectedParentRecordId]
        maintenances = Maintenance.active_objects.where{
          (complaint_date.gte starting_date) & 
          (complaint_date.lt ending_date ) & 
          (user_id.eq selectedRecordId ) & 
          (is_deleted.eq false )
        }
      end
    end
    
    customer_id_list = maintenances.collect {|x| x.customer_id}.uniq
    
    customers = Customer.where(:id => customer_id_list)
    records = []
    customers.each do |customer|
      record = {}
      record[:name] = customer.name 
      record[:data1] = maintenances.where(:customer_id => customer.id).count 
      record[:id] = customer.id 
      
      records << record
    end
    
    
    render :json => { :records => records , :total => records.count, :success => true }
  end
end
