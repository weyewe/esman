class Api2::PasswordsController < Api2::BaseMobileApiController

  def create
    
     
    resource = User.find_for_database_authentication(:email => params[:user_login][:email])


    @object  = SingleGroupLoanWeeklyCollectionReport.create_object( params[:single_group_loan_weekly_collection_report])


    if @object.errors.size == 0 
      render :json=>{:success=>true, :message=>"in progress, mate"}
    else
      render :json=>{:success=>false, :message=>"fucker, still got it wrong eh?"}
    end
  end
end