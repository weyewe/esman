require 'spec_helper'
describe CashBankMutation do
  before(:each) do
    @initial_cb1_amount = BigDecimal("50000") 
    @cb1 = CashBank.create_object(
      :name => "source name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true 
    )
    
    @cb2 = CashBank.create_object(
      :name => "target name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true 
    )
    
    cba = CashBankAdjustment.create_object(
      :cash_bank_id => @cb1.id ,
      :amount => @initial_cb1_amount ,
      :status => ADJUSTMENT_STATUS[:addition] ,
      :adjustment_date => DateTime.now  ,
      :description => nil ,
      :code => nil
    )
    
    cba.confirm_object(:confirmed_at => DateTime.now)
    @cb1.reload
  end
  
  it "has added 50000 to cb1 " do
    @cb1.amount.should ==  @initial_cb1_amount
  end

  it "allowed to create cashbank mutation" do
    cbm = CashBankMutation.create_object(
      :target_cash_bank_id => @cb2.id,
      :source_cash_bank_id => @cb1.id,
      :amount =>  BigDecimal('25000'),
      :description => "params[:description]",
      :mutation_date => DateTime.now
      )
    cbm.errors.size.should == 0
    cbm.should be_valid
  end
  
  it"source and target cannot same" do
    cbm = CashBankMutation.create_object(
      :target_cash_bank_id => @cb2.id,
      :source_cash_bank_id => @cb2.id,
      :amount =>  BigDecimal('25000'),
      :description => "params[:description]",
      :mutation_date => DateTime.now
    )
    cbm.errors.size.should_not == 0

  end
  
  it "source must valid" do
    cbm = CashBankMutation.create_object(
      :target_cash_bank_id => @cb1.id,
      :source_cash_bank_id => 20,
      :amount =>  BigDecimal('25000'),
      :description => "params[:description]",
      :mutation_date => DateTime.now
    )
    cbm.errors.size.should_not == 0
    
  end
  
  it "target must valid" do
    cbm = CashBankMutation.create_object(
      :target_cash_bank_id => 10,
      :source_cash_bank_id => @cb2.id,
      :amount =>  BigDecimal('25000'),
      :description => "params[:description]",
      :mutation_date => DateTime.now
    )
    cbm.errors.size.should_not == 0
    
  end
  
  it "mutation date must valid" do
    cbm = CashBankMutation.create_object(
      :target_cash_bank_id => @cb1.id,
      :source_cash_bank_id => @cb2.id,
      :amount =>  BigDecimal('25000'),
      :description => "params[:description]",
      :mutation_date => nil
    )
    cbm.errors.size.should_not == 0
  end
  
  it "amount must valid" do
    cbm = CashBankMutation.create_object(
      :target_cash_bank_id => @cb1.id,
      :source_cash_bank_id => @cb2.id,
      :amount =>  BigDecimal('-500'),
      :description => "params[:description]",
      :mutation_date => DateTime.now
    )
    cbm.errors.size.should_not == 0
  end
  
  it "cannot confirm if already confirmed" do
    cbm = CashBankMutation.create_object(
      :target_cash_bank_id => @cb1.id,
      :source_cash_bank_id => @cb2.id,
      :amount =>  BigDecimal('20000'),
      :description => "params[:description]",
      :mutation_date => DateTime.now
    )
    cbm.confirm_object(:confirmed_at => DateTime.now)
    cbm.confirm_object(:confirmed_at => DateTime.now)
    cbm.errors.size.should_not == 0
  end

  it "cannot confirm if source cash bank amount < cash bank mutation amount" do
    cbm = CashBankMutation.create_object(
      :target_cash_bank_id => @cb1.id,
      :source_cash_bank_id => @cb2.id,
      :amount =>  BigDecimal('60000'),
      :description => "params[:description]",
      :mutation_date => DateTime.now
    )
    cbm.confirm_object(:confirmed_at => DateTime.now)
    cbm.errors.size.should_not == 0
  end

  context "confirm cash_bank_mutation"do
    before (:each) do 
      @mutation_amount = BigDecimal('25000')
      @source_cb = @cb1 
      @target_cb = @cb2
      @cbm = CashBankMutation.create_object(
        :target_cash_bank_id => @target_cb.id,
        :source_cash_bank_id => @source_cb.id,
        :amount =>  @mutation_amount,
        :description => "params[:description]",
        :mutation_date => DateTime.now
      )
      @cb1_initial_amount = @cb1.amount
      @cb2_initial_amount = @cb2.amount
      @cbm.confirm_object(:confirmed_at => DateTime.now)
      @cb1.reload
      @cb2.reload
      @cb1_final_amount = @cb1.amount
      @cb2_final_amount = @cb2.amount
    end
    
    it "should be confirmed"do
      @cbm.is_confirmed.should be_true
    end
    
    it"should increase target cash bank amount"do
      diff1 = @cb2_final_amount - @cb2_initial_amount
      diff1.should ==  @mutation_amount
    end
    
    it "should decrease source cash bank amount"do
      diff2 =  @cb1_initial_amount - @cb1_final_amount
      diff2.should ==  @mutation_amount
    end
    
    it "should create to cash mutation"do
      CashMutation.where(:source_class => @cbm.class.to_s , :source_id => @cbm.id ).count.should == 2
      deduction_cash_mutation = CashMutation.where(
                    :source_class => @cbm.class.to_s , 
                    :source_id => @cbm.id ,
                    :status => ADJUSTMENT_STATUS[:deduction]).first
      
      deduction_cash_mutation.amount.should == @mutation_amount
      deduction_cash_mutation.cash_bank_id.should == @source_cb.id
      
      addition_cash_mutation = CashMutation.where(
                    :source_class => @cbm.class.to_s , 
                    :source_id => @cbm.id , 
                    :status => ADJUSTMENT_STATUS[:addition]).first
      addition_cash_mutation.amount.should == @mutation_amount
      addition_cash_mutation.cash_bank_id.should == @target_cb.id
      
    end
    
    context "Create cash adjusment before unconfirm" do
      
      before(:each) do 
        @deduction_amount = BigDecimal("10000")
        @cba = CashBankAdjustment.create_object(
            :cash_bank_id => @target_cb.id ,
            :amount => @deduction_amount ,
            :status => ADJUSTMENT_STATUS[:deduction] ,
            :adjustment_date => DateTime.now  ,
            :description => nil ,
            :code => nil
          )
        
        @target_cb_amount_pre_adjustment = @target_cb.amount
        @cba.confirm_object(:confirmed_at => DateTime.now)
        @target_cb.reload
        @target_cb_amount_post_adjustment = @target_cb.amount
        

      end
      
      it "should confirm adjustment" do
        @cba.errors.size.should == 0 
        @cba.is_confirmed.should be_true
      end
      
      it "should decrease  the correct amount" do
        diff = @target_cb_amount_post_adjustment  -  @target_cb_amount_pre_adjustment
        diff.should == -1 * @deduction_amount
      end
      
      context "unconfirm cash bank mutation" do
        before(:each) do
          @cbm.unconfirm_object
        end
     
        it "cannot be unconfirmed if target_cash_bank.amount < cash_bank_mutation.amount" do
          @cbm.errors.size.should_not == 0
        end
      end
      
      
    end
    
    context "Unconfirm Cash Bank Mutation" do
      before (:each) do
        @target_cb_initial_amount = @target_cb.amount
        @source_cb_initial_amount = @source_cb.amount
        @cbm.unconfirm_object
        @target_cb.reload()
        @source_cb.reload()
        @target_cb_final_amount = @target_cb.amount
        @source_cb_final_amount = @source_cb.amount
      end
      
      it "cannot be unconfirmed" do
        @cbm.unconfirm_object
        @cbm.errors.size.should_not == 0
      end
      
      it "should be unconfirmed" do
        @cbm.is_confirmed.should be_false
        @cbm.confirmed_at.should == nil
      end     
      
      it "should delete all cash mutation" do
         CashMutation.where(:source_class => @cbm.class.to_s , :source_id => @cbm.id ).count.should == 0
      end
      
      it "should update target cash bank amount to cash_bank_amount - cash_bank_mutation_amount" do
         @target_cb_final_amount.should == @target_cb_initial_amount - @cbm.amount
      end
      
      it "should update source cash bank amount to cash_bank_amount + cash_bank_mutation_amount" do
         @source_cb_final_amount.should == @source_cb_initial_amount + @cbm.amount
      end
    end
    
  end

end
