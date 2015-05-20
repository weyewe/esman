require 'spec_helper'

describe CashBankAdjustment do
  before(:each) do
    @cb = CashBank.create_object(
      :name => "awesome name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true 
    )
    
  end
  
  it "should have valid cb" do
    @cb.errors.size.should == 0
    @cb.should be_valid
  end

  
  it "should not be allowed to create cb_adjustment if there is no cashbank_id" do
    cba = CashBankAdjustment.create_object(
      :cash_bank_id => 4 ,
      :amount =>  BigDecimal("50000") ,
      :status => 3 ,
      :adjustment_date => DateTime.now  ,
      :description => nil ,
      :code => nil
    )
    
#     cba.errors.messages.each {|x| puts x}
    cba.errors.size.should_not == 0 
  end
  
  it "should have datetime" do
    cba = CashBankAdjustment.create_object(
      :cash_bank_id => @cb.id ,
      :amount =>  BigDecimal("50000") ,
      :status => 3 ,
      :adjustment_date => nil ,
      :description => nil ,
      :code => nil
    )
    
    cba.errors.size.should_not ==0 
  end
  
  it "should have valid status" do
    cba = CashBankAdjustment.create_object(
      :cash_bank_id => @cb.id,
      :amount =>  BigDecimal("50000") ,
      :status => 3 ,
      :adjustment_date => DateTime.now  ,
      :description => nil ,
      :code => nil
    )
    
    cba.errors.size.should_not == 0 
  end
  
  it "should be allowed to create cash bank adjustment" do
    cba = CashBankAdjustment.create_object(
      :cash_bank_id => @cb.id,
      :amount =>  BigDecimal("50000") ,
      :status => ADJUSTMENT_STATUS[:addition] ,
      :adjustment_date => DateTime.now  ,
      :description => nil ,
      :code => nil
    )
    
    cba.errors.size.should  == 0 
    cba.should be_valid
  end
  
  it "should not be allowed if amount is negative or doesn't make sense" do
    cba = CashBankAdjustment.create_object(
      :cash_bank_id => @cb.id,
      :amount =>   "abwef" ,
      :status => ADJUSTMENT_STATUS[:addition] ,
      :adjustment_date => DateTime.now  ,
      :description => nil ,
      :code => nil
    )
    
    cba.errors.size.should_not  == 0 
    cba.should_not be_valid
  end
  
  context "can't confirm cashbank adjustment if amount > cashbank.amount" do
    before(:each) do
      @adjustment_amount =  BigDecimal("50000") 
      @cba = CashBankAdjustment.create_object(
        :cash_bank_id => @cb.id,
        :amount =>  @adjustment_amount ,
        :status => ADJUSTMENT_STATUS[:deduction] ,
        :adjustment_date => DateTime.now  ,
        :description => nil ,
        :code => nil
      )
    end
    
    it "should not be allowed to confirm" do
      @cba.confirm_object(:confirmed_at => DateTime.now)
      @cba.errors.size.should_not == 0 
      @cba.is_confirmed.should be_false 
    end
  end
  
  context "success creating cashbank adjustment" do
    before(:each) do
      @adjustment_amount =  BigDecimal("50000") 
      @cba = CashBankAdjustment.create_object(
        :cash_bank_id => @cb.id,
        :amount =>  @adjustment_amount ,
        :status => ADJUSTMENT_STATUS[:addition] ,
        :adjustment_date => DateTime.now  ,
        :description => nil ,
        :code => nil
      )
    end
    
    it "should not allow unconfirm" do
      @cba.unconfirm_object
      
      @cba.errors.size.should_not == 0 
      
    end
    
    it "should be valid" do
      @cba.should be_valid
    end
    
    it "should be confirmable" do
      @cba.confirm_object(:confirmed_at => DateTime.now )
      @cba.is_confirmed.should be_true
    end
    
    context "confirmed cash bank adjustment" do 
      before(:each) do 
        @initial_cb_amount = @cb.amount 
        @cba.confirm_object(:confirmed_at => DateTime.now )
        @cba.is_confirmed.should be_true
        @cba.reload 
        @cb.reload
        @final_cb_amount = @cb.amount 
      end
      
      it "should increase cash_bank amount by the adjustment amount" do
        diff=  @final_cb_amount - @initial_cb_amount
        diff.should == @adjustment_amount
      end
      
      it "can be unconfirmed" do
        @cba.unconfirm_object
        @cba.is_confirmed.should be_false
        @cba.confirmed_at.should == nil
      end
      
      it "should confirm cba" do
        @cba.is_confirmed.should be_true 
      end
      
      it "should not allow double confirmation" do
        @cba.confirm_object(:confirmed_at => DateTime.now )
        @cba.errors.size.should_not == 0 
      end
      
      it "should create one cash mutation" do
        CashMutation.where(:source_class => @cba.class.to_s , :source_id => @cba.id ).count.should == 1 
       
        cash_mutation = CashMutation.where(:source_class => @cba.class.to_s , :source_id => @cba.id ).first 
        cash_mutation.source_class.should == @cba.class.to_s
        cash_mutation.source_id.should == @cba.id
        cash_mutation.amount.should == @cba.amount
        cash_mutation.status.should == @cba.status
        cash_mutation.mutation_date.should == @cba.adjustment_date
        cash_mutation.cash_bank_id.should == @cba.cash_bank_id
      end

    end
  end
  
  
end
