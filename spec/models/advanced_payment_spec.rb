require 'spec_helper'

describe AdvancedPayment do
  
  before (:each) do       
    @name_1 = "home1"
    @address_1 = "address1" 
    @startdate = DateTime.now
    @duration = 12
    @amount = BigDecimal("60000")
    @description = "description"
    @home_type1 = HomeType.create_object(
      :name => "Type1",
      :description => "description1",
      :amount => "50000"
    )
    @hm = Home.create_object(
      :name => @name_1,
      :address => @address_1,
      :home_type_id => @home_type1.id
    ) 
    
    @hm2 = Home.create_object(
      :name => @name_1,
      :address => @address_1,
      :home_type_id => @home_type1.id
    ) 
  end
  
  it "should allow create advanced_payment" do
    advp = AdvancedPayment.create_object(
      :home_id => @hm.id,
      :start_date => @startdate,
      :duration => @duration,
      :amount => @amount,
      :description => @description
    )
    advp.errors.size.should == 0
    advp.should be_valid
  end
  
  it "cannot create advanced_payment if home not valid" do
    advp = AdvancedPayment.create_object(
      :home_id => 12,
      :start_date => @startdate,
      :duration => @duration,
      :amount => @amount,
      :description => @description
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  
  it "cannot create advanced_payment if startdate not valid" do
    advp = AdvancedPayment.create_object(
      :home_id => @hm.id,
      :start_date => nil,
      :duration => @duration,
      :amount => @amount,
      :description => @description
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  
  it "cannot create advanced_payment if duration not valid" do
    advp = AdvancedPayment.create_object(
      :home_id => @hm.id,
      :start_date => @startdate,
      :duration => nil,
      :amount => @amount,
      :description => @description
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  
  it "cannot create advanced_payment if amount not valid" do
    advp = AdvancedPayment.create_object(
      :home_id => @hm.id,
      :start_date => @startdate,
      :duration => @duration,
      :amount => 0,
      :description => @description
    )
    advp.errors.size.should_not == 0
    advp.should_not be_valid
  end
  
  context "Created advance_payment" do
    before (:each) do
       @advp = AdvancedPayment.create_object(
        :home_id => @hm.id,
        :start_date => @startdate,
        :duration => @duration,
        :amount => @amount,
        :description => @description
       )
    end
    
    it "should create advance_payment" do
      @advp.errors.size.should == 0
      @advp.should be_valid
    end
    
    it "should update advance_payment" do
      @new_startdate = @startdate + 1.days
      @new_duration = @duration - 1
      @new_amount = @amount - 10000
      @new_description = "description2" 
      @advp.update_object(
        :home_id => @hm2.id,
        :start_date => @new_startdate,
        :duration => @new_duration,
        :amount => @new_amount,
        :description => @new_description
        )
      @advp.errors.size.should == 0
      @advp.should be_valid
      @advp.start_date.should == @new_startdate
      @advp.duration.should == @new_duration
      @advp.amount.should == @new_amount
      @advp.description.should == @new_description
    end
    
    it "cannot update advanced_payment if home not valid" do
    @advp.update_object(
      :home_id => 12,
      :start_date => @startdate,
      :duration => @duration,
      :amount => @amount,
      :description => @description
    )
    @advp.errors.size.should_not == 0
    @advp.should_not be_valid
    end
  
    it "cannot update advanced_payment if startdate not valid" do
      @advp.update_object(
        :home_id => @hm.id,
        :start_date => nil,
        :duration => @duration,
        :amount => @amount,
        :description => @description
      )
      @advp.errors.size.should_not == 0
      @advp.should_not be_valid
    end
  
    it "cannot update advanced_payment if duration not valid" do
      @advp.update_object(
        :home_id => @hm.id,
        :start_date => @startdate,
        :duration => nil,
        :amount => @amount,
        :description => @description
      )
      @advp.errors.size.should_not == 0
      @advp.should_not be_valid
    end
  
    it "cannot update advanced_payment if amount not valid" do
      @advp.update_object(
        :home_id => @hm.id,
        :start_date => @startdate,
        :duration => @duration,
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
  
    context "create invoice in the same month" do
      before(:each) do
        @invoice = Invoice.create_object(
          :source_id => @advp.id,
          :source_class => @advp.class.to_s,
          :home_id => @advp.home_id,
          :amount => @advp.amount,
          :invoice_date => DateTime.now,
          :description => @advp.description
         )
      end
    
      it "should have created the invoice" do 
        @invoice.errors.size.should == 0 
        @invoice.should be_valid 
      end

      context "confirm advance payment even though there is invoice in the same month" do
        before(:each) do

          @advp.confirm_object(:confirmed_at => DateTime.now)
        end

        it "should not confirm the advance payment" do

          @advp.is_confirmed.should be_false 
        end
      end
    
    end
    
    context "Confirmed advance_payment" do
      before(:each) do
       @advp.confirm_object(:confirmed_at => DateTime.now)
      end
      
      it "cannot update advanced_payment if already confirmed" do
        @advp.update_object(
          :home_id => @hm2,
          :start_date => @startdate,
          :duration => @duration,
          :amount => @amount,
          :description => @description
        )
        @advp.errors.size.should_not == 0
      end
      
      it "cannot confirm if already confirmed" do
        @advp.confirm_object(:confirmed_at => DateTime.now)
        @advp.errors.size.should_not == 0
       
      end
      
      it "should create 12 invoice and 1 receivable" do
        invoice_count = Invoice.where(
          :source_id => @advp.id,
          :source_class => @advp.class.to_s,
          :home_id => @advp.home_id,
          :amount => BigDecimal(@advp.amount/@advp.duration),
          :invoice_date => @advp.confirmed_at
          ).count
        receivable_count = Receivable.where(
          :source_id => @advp.id,
          :source_class => @advp.class.to_s,
          :amount => BigDecimal(@advp.amount)
          ).count
        invoice_count.should == @advp.duration
        receivable_count.should == 1
      end
      
      context "Unconfirm advance_payment" do
        before(:each) do
          @advp.unconfirm_object
        end
        
        it "should unconfirm advanced_payment" do
          @advp.errors.size.should == 0
          @advp.is_confirmed.should be_false
          @advp.confirmed_at == nil
        end
        
        it "cannot unconfirm if not confirmed" do
          @advp.unconfirm_object
          @advp.errors.size.should_not == 0
        end
        
        it "should delete 12 created invoice and 1 receivable" do
          invoice_count = Invoice.where(
              :source_id => @advp.id,
              :source_class => @advp.class.to_s,
              :home_id => @advp.home_id,
              :is_deleted => true
          ).count
          receivable_count = Receivable.where(
                :source_id => @advp.id,
                :source_class => @advp.class.to_s,
                :amount => BigDecimal(@advp.amount),
                :is_deleted => true
          ).count
          invoice_count.should == 12
          receivable_count.should == 1
        end
        
      end
      
    end
    
  end
  
end
