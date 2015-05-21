require 'spec_helper'

describe DepositDocument do
  
  before (:each) do    
    
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
    
    @user1 = User.create_main_user(  
      :name => "Admin", 
      :email => "admin@gmail.com" ,
      :password => "willy1234", 
      :password_confirmation => "willy1234") 
  
    @user2 = User.create_main_user(  
      :name => "Admin2", 
      :email => "admin2@gmail.com" ,
      :password => "willy1234", 
      :password_confirmation => "willy1234") 
    
    @hmt = HomeType.create_object(
      :name => "Type1",
      :description => "description",
      :amount => "50000"
    )
    @hm1 = Home.create_object(
      :name => "Home1",
      :address => "Address1",
      :home_type_id => @hmt.id
    )
    
    @hm2 = Home.create_object(
      :name => "Home2",
      :address => "Address2",
      :home_type_id => @hmt.id
      )
    
    @description1 = "description" 
    @deposit_date1 = DateTime.now
    @description2 = "description" 
    @deposit_date2 = DateTime.now + 1.days
    @amount_charge = BigDecimal("20000")
    @amount_charge_full = BigDecimal("60000")
    @amount_deposit1 = BigDecimal("60000")
    @amount_deposit2 = BigDecimal("80000")
    @description = "description"
  end
  
  it "should allow create deposit_document" do
    advp = DepositDocument.create_object(
      :user_id => @user1.id,
      :home_id => @hm1.id,
      :deposit_date => @deposit_date1,
      :description => @description1,
      :amount_deposit => @amount_deposit1
    )
    advp.errors.size.should == 0
    advp.should be_valid
  end
  
  it "cannot create deposit_document if user not valid" do
    advp = DepositDocument.create_object(
      :user_id => 99999,
      :home_id => @hm1.id,
      :deposit_date => @deposit_date1,
      :description => @description1,
      :amount_deposit => @amount_deposit1
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  
  it "cannot create deposit_document if home not valid" do
    advp = DepositDocument.create_object(
      :user_id => @user1.id,
      :home_id => 255,
      :deposit_date => @deposit_date1,
      :description => @description1,
      :amount_deposit => @amount_deposit1     
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
    
  it "cannot create deposit_document if deposit_date not valid" do
    advp = DepositDocument.create_object(
      :user_id => @user1.id,
      :home_id => @hm1.id,
      :deposit_date => nil,
      :description => @description1,
      :amount_deposit => @amount_deposit1
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  
  it "cannot create deposit_document if amount_deposit not valid" do
    advp = DepositDocument.create_object(
      :user_id => @user1.id,
      :home_id => @hm1.id,
      :deposit_date => @deposit_date1,
      :description => @description1,
      :amount_deposit => 0
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  
  context "Created deposit_document" do
    before (:each) do
       @advp = DepositDocument.create_object(
        :user_id => @user1.id,
        :home_id => @hm1.id,
        :deposit_date => @deposit_date1,
        :description => @description1,
        :amount_deposit => @amount_deposit1
       )
    end
    
    it "should create deposit_document" do
      @advp.errors.size.should == 0
      @advp.should be_valid
    end
    
    it "should update deposit_document" do
      @advp.update_object(
        :user_id => @user2.id,
        :home_id => @hm2.id,
        :deposit_date => @deposit_date2,
        :description => @description2,
        :amount_deposit => @amount_deposit2
        )
      @advp.errors.size.should == 0
      @advp.should be_valid
      @advp.user_id.should == @user2.id
      @advp.home_id.should == @hm2.id
      @advp.deposit_date.should == @deposit_date2
      @advp.description.should == @description2
      @advp.amount_deposit.should == @amount_deposit2
    end
    
    it "cannot update deposit_document if user not valid" do
      @advp.update_object(
          :user_id => 255,
          :home_id => @hm2.id,
          :deposit_date => @deposit_date2,
          :description => @description2,
          :amount_deposit => @amount_deposit2
      )
      @advp.errors.size.should_not == 0
      @advp.should_not be_valid
    end
  
    it "cannot update deposit_document if home not valid" do
      @advp.update_object(
          :user_id => @user2.id,
          :home_id => 233,
          :deposit_date => @deposit_date2,
          :description => @description2,
          :amount_deposit => @amount_deposit2
      )
      @advp.errors.size.should_not == 0
      @advp.should_not be_valid
    end
     
    it "cannot update deposit_document if deposit_date not valid" do
      @advp.update_object(
          :user_id => @user2.id,
          :home_id => @hm2.id,
          :deposit_date => nil,
          :description => @description2,
          :amount_deposit => @amount_deposit2
      )
      @advp.errors.size.should_not == 0
      @advp.should_not be_valid
    end
    
    it "cannot update deposit_document if amount_deposit not valid" do
      @advp.update_object(
          :user_id => @user2.id,
          :home_id => @hm2.id,
          :deposit_date => @deposit_date2,
          :description => @description2,
          :amount_deposit => 0
      )
      @advp.errors.size.should_not == 0
      @advp.should_not be_valid
    end
    
    it "should confirm_deposit_document" do
        @advp.confirm_object(:confirmed_at => DateTime.now)
        @advp.errors.size.should == 0
        @advp.is_confirmed.should be_true
        @advp.should be_valid
    end
  
    
    context "Confirmed deposit_document" do
      before(:each) do
       @advp.confirm_object(:confirmed_at => DateTime.now)
      end
      
      it "cannot update deposit_document if already confirmed" do
        @advp.update_object(
          :user_id => @user2.id,
          :home_id => @hm2.id,
          :deposit_date => @deposit_date2,
          :description => @description2
        )
        @advp.errors.size.should_not == 0
      end
      
      it "cannot confirm if already confirmed" do
        @advp.confirm_object(:confirmed_at => DateTime.now)
        @advp.errors.size.should_not == 0
       
      end
      
      it "should create  1 receivable" do
        receivable_count = Receivable.where(
          :source_id => @advp.id,
          :source_class => @advp.class.to_s,
          :amount => BigDecimal(@advp.amount_deposit)
          ).count
        receivable_count.should == 1
      end
      
      context "Unconfirm deposit_document" do
        before(:each) do
          @advp.unconfirm_object
        end
        
        it "should unconfirm deposit_document" do
          @advp.errors.size.should == 0
          @advp.is_confirmed.should be_false
          @advp.confirmed_at == nil
        end
        
        it "cannot unconfirm if not confirmed" do
          @advp.unconfirm_object
          @advp.errors.size.should_not == 0
        end
        
        it "should delete 1 receivable" do
          receivable_count = Receivable.where(
                :source_id => @advp.id,
                :source_class => @advp.class.to_s,
                :amount => BigDecimal(@advp.amount_deposit),
                :is_deleted => true
          ).count
          receivable_count.should == 1
        end
      end
      
      context "Finished Deposit Document with not full amount charge" do
        before(:each) do
           @advp.finish_object(
             :confirmed_at => DateTime.now,
             :amount_charge => @amount_charge
             )
        end

        it "should set is_finished to true" do
          @advp.is_finished.should be_true
        end

        it "should create 1 payable" do
          diff = @advp.amount_deposit - @advp.amount_charge
          payable_count = Payable.where(
            :source_id => @advp.id,
            :source_class => @advp.class.to_s,
            :amount => diff,
            :is_deleted => false
          ).count
          payable_count.should == 1
        end

        context"Unfinished deposit_document" do
          before(:each)do
            @advp.unfinish_object
          end

          it "should set is_finished to false" do
            @advp.is_finished.should be false
          end

          it "should delete 1 payable" do
            diff = @advp.amount_deposit - @advp.amount_charge
            payable_count = Payable.where(
              :source_id => @advp.id,
              :source_class => @advp.class.to_s,
              :amount => diff,
              :is_deleted => true
            ).count
            payable_count.should == 1
          end

          it "cannot unfinish again" do
            @advp.unfinish_object
            @advp.errors.size.should_not == 0
          end       
        end
      end
      
      context "Finished Deposit Document with full amount charge" do
        before(:each) do
           @advp.finish_object(
             :confirmed_at => DateTime.now,
             :amount_charge => @amount_charge_full
             )
        end

        it "should set is_finished to true" do
          @advp.is_finished.should be_true
        end

        it "should not create payable" do        
          payable_count = Payable.where(
            :source_id => @advp.id,
            :source_class => @advp.class.to_s,            
          ).count
          payable_count.should == 0
        end

        context"Unfinished deposit_document" do
          before(:each)do
            @advp.unfinish_object
          end

          it "should set is_finished to false" do
            @advp.is_finished.should be false
          end

          it "should not delete 1 payable" do
            payable_count = Payable.where(
              :source_id => @advp.id,
              :source_class => @advp.class.to_s,             
              :is_deleted => true
            ).count
            payable_count.should == 0
          end

          it "cannot unfinish again" do
            @advp.unfinish_object
            @advp.errors.size.should_not == 0
          end       
        end
      end
      
    end  
  end 
end
