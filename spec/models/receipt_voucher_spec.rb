require 'spec_helper'

describe ReceiptVoucher do
  before(:each) do
    @description = "description"
    @new_description = "new description"
    
    @receipt_date = DateTime.now
    @new_receipt_date = DateTime.now + 1.days
    @receivable_amount = BigDecimal("50000")
  end
  
  context "create receivable through advanced payment"
    before(:each) do
      @home_type1 = HomeType.create_object(
        :name => "Type1",
        :description => "description1",
        :amount => "50000"
      )
      @hm = Home.create_object(
        :name =>"@name_1",
        :address => "address_1",
        :home_type_id => @home_type1.id
      ) 
      @advp = AdvancedPayment.create_object(
        :home_id => @hm.id,
        :start_date => DateTime.now,
        :duration => 12,
        :amount =>  @receivable_amount,
        :description => "AdvancePaymentDesc"
      )
      @advp.confirm_object(:confirmed_at => DateTime.now)
      
      @advp2 = AdvancedPayment.create_object(
        :home_id => @hm.id,
        :start_date => DateTime.now + 1.months,
        :duration => 12,
        :amount =>  @receivable_amount,
        :description => "AdvancePaymentDesc"
      )
      @advp2.confirm_object(:confirmed_at => DateTime.now)
      
      @receivable = Receivable.where(
        :source_id => @advp.id,
        :source_class => @advp.class.to_s,
        :amount => BigDecimal(@advp.amount),
        :is_deleted => false
      )
      
       @receivable2 = Receivable.where(
        :source_id => @advp2.id,
        :source_class => @advp2.class.to_s,
        :amount => BigDecimal(@advp2.amount),
        :is_deleted => false
      )
      
    end
  
   it "should create each receivable" do
      @receivable.count.should == 1
      @receivable2.count.should == 1
    end
    
    context "create cashBank and user" do
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
        
       @user = User.create_main_user(  
          :name => "Admin", 
          :email => "admin@gmail.com" ,
          :password => "willy1234", 
          :password_confirmation => "willy1234"
       ) 
        
       @user2 = User.create_main_user(  
          :name => "Admin2", 
          :email => "admin2@gmail.com" ,
          :password => "willy1234", 
          :password_confirmation => "willy1234"
       ) 
       @cb = CashBank.create_object(
          :name => "@name_",
          :description => "ehaufeahifi heaw",
          :is_bank => true
       )
        
       @cb2 = CashBank.create_object(
          :name => "@name_",
          :description => "ehaufeahifi heaw",
          :is_bank => true
       )
      end
     
      it "should create cashBank" do
        @cb.should be_valid
        @cb.errors.size.should == 0 
      end
       
      it "should create receipt voucher" do
        rv = ReceiptVoucher.create_object(
           :description => @description, 
           :receipt_date => @receipt_date,
           :receivable_id => @receivable.first.id,
           :cash_bank_id => @cb.id,
           :user_id =>@user.id
         ) 
         rv.should be_valid
         rv.errors.size.should == 0 
      end
      
      it "cannot create receipt voucher if receiptdate is valid" do
        rv = ReceiptVoucher.create_object(
           :description => @description, 
           :receipt_date => nil,
           :receivable_id => @receivable.first.id,
           :cash_bank_id => @cb.id,
           :user_id =>@user.id
         ) 
         rv.errors.size.should_not == 0 
         rv.should_not be_valid
      end
      
      it "cannot create receipt voucher if receivable is valid" do
        rv = ReceiptVoucher.create_object(
           :description => @description, 
           :receipt_date => @receipt_date,
           :receivable_id => 255,
           :cash_bank_id => @cb.id,
           :user_id =>@user.id
        ) 
         rv.errors.size.should_not == 0 
         rv.should_not be_valid
      end
      
      it "cannot create receipt voucher if cashbank is valid" do
        rv = ReceiptVoucher.create_object(
           :description => @description, 
           :receipt_date => @receipt_date,
           :receivable_id => @receivable.first.id,
           :cash_bank_id => 255,
           :user_id =>@user.id
         ) 
         rv.errors.size.should_not == 0 
         rv.should_not be_valid
      end
      
      it "cannot create receipt voucher if user_id is valid" do
        rv = ReceiptVoucher.create_object(
           :description => @description, 
           :receipt_date => @receipt_date,
           :receivable_id => @receivable.first.id,
           :cash_bank_id => @cb.id,
           :user_id =>255
         ) 
         rv.errors.size.should_not == 0 
         rv.should_not be_valid
      end
      
      context "create receipt voucher" do
        before(:each) do
         @rv = ReceiptVoucher.create_object(
           :description => @description, 
           :receipt_date => @receipt_date,
           :receivable_id => @receivable.first.id,
           :cash_bank_id => @cb.id,
           :user_id =>@user.id
         ) 
        end
        
        it "should create receipt voucher" do
          @rv.should be_valid
          @rv.errors.size.should == 0 
        end
        
        it "should update receipt voucher" do
          @rv.update_object(
             :description => @new_description, 
             :receipt_date => @new_receipt_date,
             :receivable_id => @receivable2.first.id,
             :cash_bank_id => @cb2.id,
             :user_id =>@user2.id
            )
          @rv.should be_valid
          @rv.errors.size.should == 0 
          @rv.description.should == @new_description
          @rv.receipt_date.should == @new_receipt_date
          @rv.receivable_id.should == @receivable2.first.id
          @rv.cash_bank_id.should == @cb2.id
          @rv.user_id.should == @user2.id
        end
        
        it "cannot update receipt voucher if receiptdate is valid" do
          @rv.update_object(
             :description => @description, 
             :receipt_date => nil,
             :receivable_id => @receivable.first.id,
             :cash_bank_id => @cb.id,
             :user_id =>@user2.id
            )
          @rv.should_not be_valid
          @rv.errors.size.should_not == 0 
        end
        
        it "cannot update receipt voucher if receivable is valid" do
          @rv.update_object(
             :description => @description, 
             :receipt_date => @receipt_date,
             :receivable_id => 245,
             :cash_bank_id => @cb.id,
             :user_id =>@user2.id
            )
          @rv.should_not be_valid
          @rv.errors.size.should_not == 0 
        end
        
        it "cannot update receipt voucher if user is valid" do
          @rv.update_object(
             :description => @description, 
             :receipt_date => @receipt_date,
             :receivable_id => @receivable.first.id,
             :cash_bank_id => @cb.id,
             :user_id => 255
            )
          @rv.should_not be_valid
          @rv.errors.size.should_not == 0 
        end
        
        it "cannot update receipt voucher if cashbank is valid" do
          @rv.update_object(
             :description => @description, 
             :receipt_date => @receipt_date,
             :receivable_id => @receivable.first.id,
             :cash_bank_id => 245,
             :user_id =>@user2.id
            )
          @rv.should_not be_valid
          @rv.errors.size.should_not == 0 
        end
        
        it "should confirm receipt voucher" do
          @rv.confirm_object(:confirmed_at => DateTime.now)    
          @rv.errors.size.should == 0
        end
        
        it "should delete receipt voucher" do
          @rv.delete_object
          @rv.is_deleted.should be_true
        end
        
        context "confirm receipt voucher" do
          before(:each) do
             @rv.confirm_object(:confirmed_at => DateTime.now)  
          end
          
          it "should change receipt voucher is confirmed to true" do
            @rv.is_confirmed.should be_true
          end
          
          
          it "cannot update receipt voucher if already confirmed" do
          @rv.update_object(
             :description => @description, 
             :receipt_date => @receipt_date,
             :receivable_id => @receivable.first.id,
             :cash_bank_id => @cb.id,
             :user_id =>@user.id
            )
          @rv.errors.size.should_not == 0 
          end
          
          it "cannot delete receipt voucher if already confirmed" do
          @rv.delete_object
          @rv.errors.size.should_not == 0 
          end
          
          it "should make cash mutation" do
            cashmutation_count = CashMutation.where(
               :source_class => @rv.class.to_s, 
               :source_id => @rv.id  
              ).count
            cashmutation_count.should == 1
          end
          
          it "should change cashbank amount to 60000" do
            @rv.cash_bank.amount.should == @receivable_amount
          end
          
          it "should change receivable remaining amount to 0" do
            @rv.receivable.remaining_amount.should == BigDecimal("0")
          end
          
          it  "cannot confirm receipt voucher if already confirmed" do
            @rv.confirm_object(:confirmed_at => DateTime.now)  
            @rv.errors.size.should_not == 0  
          end
          
          it "can unconfirm receipt voucher" do
            @rv.unconfirm_object
            @rv.errors.size.should == 0
          end
          
          context "Unconfirm receipt Voucher" do
            before(:each) do
              @rv.unconfirm_object
            end
            
            it "receipt voucher is_confirmed should be false" do          
              @rv.errors.size.should == 0
              @rv.is_confirmed.should be_false
            end
            
            it "should delete cashmutation" do
               cashmutation_count = CashMutation.where(
                 :source_class => @rv.class.to_s, 
                 :source_id => @rv.id  
               ).count
               cashmutation_count.should == 0
            end
            
            it "should change cashbank amount to 0" do
              @rv.cash_bank.amount.should == BigDecimal("0")
            end
          
            it "should change receivable remaining amount to 60000" do
              @rv.receivable.remaining_amount.should == @receivable_amount
            end
            
          end
          
        end
      end
    end
    

end
