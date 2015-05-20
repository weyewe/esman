require 'spec_helper'

describe PaymentRequest do
  
  before (:each) do       
    @name_1 = "vendor1"
    @address_1 = "address1" 
    @requestdate = DateTime.now

    @amount = BigDecimal("60000")
    @description = "description"
    @vd = Vendor.create_object(
      :name => @name_1,
      :address => @address_1,
      :description => @description_1
    )
    
    @vd2 = Vendor.create_object(
      :name => "name_1",
      :address => "@address_1",
      :description =>" @description_1"
    )
  end
  
  it "should allow create payment_request" do
    advp = PaymentRequest.create_object(
      :vendor_id => @vd.id,
      :request_date => @requestdate,
      
      :amount => @amount,
      :description => @description
    )
    advp.errors.size.should == 0
    advp.should be_valid
  end
  
  it "cannot create payment_request if vendor not valid" do
    advp = PaymentRequest.create_object(
      :vendor_id => 12,
      :request_date => @requestdate,
      
      :amount => @amount,
      :description => @description
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  
  it "cannot create payment_request if requestdate not valid" do
    advp = PaymentRequest.create_object(
      :vendor_id => @vd.id,
      :request_date => nil,
      
      :amount => @amount,
      :description => @description
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  

  
  it "cannot create payment_request if amount not valid" do
    advp = PaymentRequest.create_object(
      :vendor_id => @vd.id,
      :request_date => @requestdate,
      
      :amount => 0,
      :description => @description
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  
  context "Created advance_payment" do
    before (:each) do
       @advp = PaymentRequest.create_object(
        :vendor_id => @vd.id,
        :request_date => @requestdate,
        
        :amount => @amount,
        :description => @description
       )
    end
    
    it "should create advance_payment" do
      @advp.errors.size.should == 0
      @advp.should be_valid
    end
    
    it "should update advance_payment" do
      @new_requestdate = @requestdate + 1.days
      @new_amount = @amount - 10000
      @new_description = "description2" 
      @advp.update_object(
        :vendor_id => @vd2.id,
        :request_date => @new_requestdate,
        :amount => @new_amount,
        :description => @new_description
        )
      @advp.errors.size.should == 0
      @advp.should be_valid
      @advp.request_date.should == @new_requestdate
      @advp.amount.should == @new_amount
      @advp.description.should == @new_description
    end
    
    it "cannot update payment_request if vendor not valid" do
    @advp.update_object(
      :vendor_id => 12,
      :request_date => @requestdate,
      
      :amount => @amount,
      :description => @description
    )
    @advp.errors.size.should_not == 0
    @advp.should_not be_valid
    end
  
    it "cannot update payment_request if requestdate not valid" do
      @advp.update_object(
        :vendor_id => @vd.id,
        :request_date => nil,
        
        :amount => @amount,
        :description => @description
      )
      @advp.errors.size.should_not == 0
      @advp.should_not be_valid
    end
     
    it "cannot update payment_request if amount not valid" do
      @advp.update_object(
        :vendor_id => @vd.id,
        :request_date => @requestdate,
        
        :amount => 0,
        :description => @description
      )
      @advp.errors.size.should_not == 0
      @advp.should_not be_valid
    end
  
    
    it "should confirm_advance_payment" do
        @advp.confirm_object(:confirmed_at => DateTime.now)
        @advp.errors.size.should == 0
        @advp.is_confirmed.should be_true
        @advp.should be_valid
    end
  
    
    context "Confirmed advance_payment" do
      before(:each) do
       @advp.confirm_object(:confirmed_at => DateTime.now)
      end
      
      it "cannot update payment_request if already confirmed" do
        @advp.update_object(
          :vendor_id => @vd2,
          :request_date => @requestdate,
          
          :amount => @amount,
          :description => @description
        )
        @advp.errors.size.should_not == 0
      end
      
      it "cannot confirm if already confirmed" do
        @advp.confirm_object(:confirmed_at => DateTime.now)
        @advp.errors.size.should_not == 0
       
      end
      
      it "should create  1 payable" do
        payable_count = Payable.where(
          :source_id => @advp.id,
          :source_class => @advp.class.to_s,
          :amount => BigDecimal(@advp.amount)
          ).count
        payable_count.should == 1
      end
      
      context "Unconfirm advance_payment" do
        before(:each) do
          @advp.unconfirm_object
        end
        
        it "should unconfirm payment_request" do
          @advp.errors.size.should == 0
          @advp.is_confirmed.should be_false
          @advp.confirmed_at == nil
        end
        
        it "cannot unconfirm if not confirmed" do
          @advp.unconfirm_object
          @advp.errors.size.should_not == 0
        end
        
        it "should delete 1 payable" do
          payable_count = Payable.where(
                :source_id => @advp.id,
                :source_class => @advp.class.to_s,
                :amount => BigDecimal(@advp.amount),
                :is_deleted => true
          ).count
          payable_count.should == 1
        end
        
      end
      
    end
    
  end
end
