require 'spec_helper'

describe HomeAssignment do
  
  before(:each) do
    role = {
      :system => {
        :administrator => true
      }
    }

    @admin_role = Role.create!(
      :name        => ROLE_NAME[:admin],
      :title       => 'Administrator',
      :description => 'Role for administrator',
      :the_role    => role.to_json
    )

    
    @hmt = HomeType.create_object(
      :name => "Type1",
      :description => "description",
      :amount => "50000"
    )
    
    @hm = Home.create_object(
      :name => "Home1",
      :address => "Address1",
      :home_type_id => @hmt.id
    )
    
    @hm2 = Home.create_object(
      :name => "Home2",
      :address => "Address2",
      :home_type_id => @hmt.id
      )
    @user = User.create_main_user(  
      :name => "Admin", 
      :email => "admin@gmail.com" ,
      :password => "willy1234", 
      :password_confirmation => "willy1234") 

     
  end
  
  it "should create user" do
    @user.errors.size.should == 0 
    @user.should be_valid
  end
  

  it "should create homeType,home" do
    @hmt.errors.size.should == 0
    @hmt.should be_valid
    @hm.errors.size.should == 0
    @hm.should be_valid
  end  
  
  it "should create HomeAssignment" do
    hma = HomeAssignment.create_object(
      :user_id => @user.id,
      :home_id => @hm.id,
      :assignment_date => DateTime.now
    )
    hma.errors.size.should == 0
    hma.should be_valid
    
  end
  
  it "should not create HomeAssignment if user_id is not valid" do
  hma = HomeAssignment.create_object(
      :user_id => 10,
      :home_id => @hm.id,
      :assignment_date => DateTime.now
    )
    hma.errors.size.should_not == 0
    hma.should_not be_valid
  end
  
  it "should not create HomeAssignment if home_id is not valid" do
  hma = HomeAssignment.create_object(
      :user_id => @user.id,
      :home_id => 12,
      :assignment_date => DateTime.now
    )
    hma.errors.size.should_not == 0
    hma.should_not be_valid
  end
  
  context "create new home assignment" do
    
    before (:each) do
    @hma = HomeAssignment.create_object(
      :user_id => @user.id,
      :home_id => @hm.id,
      :assignment_date => DateTime.now
    )
    end
   
   it "Should Create new Home assigment" do
       @hma.errors.size.should == 0
       @hma.should be_valid
   end
   
    it "should not create home assignment if user already assign to same home" do
    hma1 = HomeAssignment.create_object(
      :user_id => @user.id,
      :home_id => @hm.id,
      :assignment_date => DateTime.now
    )
      hma1.errors.size.should_not == 0
      hma1.should_not be_valid
    end
  
    it "should not update if user is not valid" do
    hma1 = @hma.update_object(
        :user_id => 12,
        :home_id => @hm.id,
        :assignment_date => DateTime.now
      )
      @hma.errors.size.should_not == 0
      @hma.should_not be_valid
    end

  
    it "should not update if home is not valid" do
      hma1 = @hma.update_object(
          :user_id => @user.id,
          :home_id => 12,
          :assignment_date => DateTime.now
        )
        @hma.errors.size.should_not == 0
        @hma.should_not be_valid
    end
  
    context "Delete Home_assignment" do 
      before (:each) do
         @hma.delete_object 
      end
    

      it "should set is_deleted == true" do
        @hma.is_deleted.should be_true
      end

    end
    
    context "create another new home assigment" do
      before (:each) do
        @hma2 = HomeAssignment.create_object(
          :user_id => @user.id,
          :home_id => @hm2.id,
          :assignment_date => DateTime.now
        )
      end
      
      it "should create new home assigment" do
        @hma2.errors.size.should == 0 
        @hma2.should be_valid
      end
      
      it "should assign home1 and home2 to user1" do
        @hma.user_id.should == @user.id
        @hma2.user_id.should == @user.id
      end
      
      it "update hma2 to home1" do
        puts "Gonna update home assignment so that we will have double assignment\n"*5
        @hma2.update_object(
          :user_id => @user.id,
          :home_id => @hm.id,
          :assignment_date => DateTime.now
        )
        @hma2.errors.size.should_not == 0 
        @hma2.should_not be_valid
      end
      
    end
  end
end
