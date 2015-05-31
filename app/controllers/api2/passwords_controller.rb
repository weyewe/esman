class Api2::PasswordsController < Api2::BaseMobileApiController

   
 
  def update
    @user = current_user

    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      flash[:notice] = "Password is updated successfully."
    else
      flash[:error] = "Fail to update password. Check your input!"
    end
    
    success_value = @user.errors.size == 0 


    
    if @user.errors.size == 0 
      new_token = @user.generate_authentication_token
      @user.authentication_token = new_token 
      @user.save 
      
      render :json => {
        :success => true, 
        :message => "Pasword is updated succsesfully",
        :auth_token => @user.authentication_token
      }
    else
      render :json => {
        :success => false, 
        :message => "Fail to update password: #{@user.errors.first}" 
      }
    end
    
  end
end