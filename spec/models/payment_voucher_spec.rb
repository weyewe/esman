require 'spec_helper'

describe PaymentVoucher do
 
  before(:each) do
    @vd = Vendor.create_object(
      :name => "vendor1",
      :address => "address_1",
      :description => "description_1"
    )
    
    @vd2 = Vendor.create_object(
      :name => "vendor2",
      :address => "address_2",
      :description => "description_2"
    )
    
    @cb = CashBank.create_object(
      :name => "awesome name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true 
    )
    
    @cb2 = CashBank.create_object(
      :name => "awesome name2" ,
      :description => "ehaufeahifi heaw2",
      :is_bank => true 
    )
    
    @cba = CashBankAdjustment.create_object(
        :cash_bank_id => @cb.id,
        :amount =>  BigDecimal("90000") ,
        :status => ADJUSTMENT_STATUS[:addition] ,
        :adjustment_date => DateTime.now  ,
        :description => nil ,
        :code => nil
      )
  
    @cba.confirm_object(:confirmed_at => DateTime.now )
    
    @advp = PaymentRequest.create_object(
      :vendor_id => @vd.id,
      :request_date => DateTime.now,
      :amount => BigDecimal("50000"),
      :description => @description
    )
    
    @advp.confirm_object(:confirmed_at => DateTime.now )
    @payable = Payable.where(
          :source_id => @advp.id,
          :source_class => @advp.class.to_s,
          :amount => BigDecimal(@advp.amount)
    )
         
    @advp2 = PaymentRequest.create_object(
      :vendor_id => @vd.id,
      :request_date => DateTime.now,
      :amount => BigDecimal("20000"),
      :description => @description
    )
    
    @advp2.confirm_object(:confirmed_at => DateTime.now )
    @payable2 = Payable.where(
          :source_id => @advp2.id,
          :source_class => @advp2.class.to_s,
          :amount => BigDecimal(@advp2.amount)
    )
    
  end
  
  it "should create payment_voucher" do
    pv = PaymentVoucher.create_object(
      :description => "pv desc",
      :payment_date => DateTime.now,
      :vendor_id => @vd.id,
      :cash_bank_id => @cb.id
      )
    pv.errors.size.should == 0
    pv.should be_valid
  end
  
  it "cannot create payment_voucher if payment_date is not valid" do
    pv = PaymentVoucher.create_object(
      :description => "pv desc",
      :payment_date => nil,
      :vendor_id => @vd.id,
      :cash_bank_id => @cb.id
      )
    pv.errors.size.should_not == 0
    pv.should_not be_valid
  end
  
  it "cannot create payment_voucher if vendor_id is not valid" do
    pv = PaymentVoucher.create_object(
      :description => "pv desc",
      :payment_date => DateTime.now,
      :vendor_id => 222,
      :cash_bank_id => @cb.id
      )
    pv.errors.size.should_not == 0
    pv.should_not be_valid
  end
  
  it "cannot create payment_voucher if cashbank_id is not valid" do
    pv = PaymentVoucher.create_object(
      :description => "pv desc",
      :payment_date => DateTime.now,
      :vendor_id => @vd.id,
      :cash_bank_id => 222
      )
    pv.errors.size.should_not == 0
    pv.should_not be_valid
  end
  
  context "create payment_voucher" do
    before(:each) do
    @pv = PaymentVoucher.create_object(
      :description => "pv desc",
      :payment_date => DateTime.now,
      :vendor_id => @vd.id,
      :cash_bank_id => @cb.id
      )
    end
    
    it "should update payment_voucher" do
      @new_desc = "pv des2"
      @new_payment_date = DateTime.now + 1.days
      @pv.update_object(
        :description => @new_desc,
        :payment_date => @new_payment_date,
        :vendor_id => @vd2.id,
        :cash_bank_id => @cb2.id
       )
      @pv.should be_valid
      @pv.errors.size.should == 0 
      @pv.description.should == @new_desc
      @pv.payment_date.should == @new_payment_date
      @pv.vendor_id.should == @vd2.id
      @pv.cash_bank_id.should == @cb2.id     
    end
    
    it "cannot unconfirm payment_voucher if have no detail" do
      @pv.confirm_object(:confirmed_at => DateTime.now)
      @pv.errors.size.should_not == 0
    end
 
    context "Insert 2 detail" do
      before(:each) do
        @pvd = PaymentVoucherDetail.create_object(
          :payment_voucher_id => @pv.id,
          :payable_id => @payable.first.id
          )
        
        @pvd = PaymentVoucherDetail.create_object(
          :payment_voucher_id => @pv.id,
          :payable_id => @payable2.first.id
          )
        @pv.reload
      end
      
      it "should have 2 detail and payment_voucher.amount == 70000" do
        @pv.payment_voucher_details.count.should == 2
        @pv.amount.should == BigDecimal("70000")
      end
      
      it "should confirmed paymentVoucher" do
        @pv.confirm_object(:confirmed_at => DateTime.now)
        @pv.errors.size.should == 0     
      end
      
      it "cannot delete payment_voucher if have detail" do
        @pv.delete_object
        @pv.errors.size.should_not == 0    
      end
      
      it "cannot update payment_voucher if have detail" do
        @new_desc = "pv des2"
        @new_payment_date = DateTime.now + 1.days
        @pv.update_object(
          :description => @new_desc,
          :payment_date => @new_payment_date,
          :vendor_id => @vd2.id,
          :cash_bank_id => @cb2.id
        )
        @pv.errors.size.should_not == 0 
      end
      
      context "confirm payment_voucher" do
        before(:each) do
          @initial_payable_amount = @payable.first.amount
          @initial_payable2_amount = @payable2.first.amount
          @pv.confirm_object(:confirmed_at => DateTime.now)
          @cb.reload
          @payable.reload
          @payable2.reload
        end
        
        it "should update cashbank amount to 20000" do
          @cb.amount.should == BigDecimal("20000")
        end
        
        it "should create 2 cash mutation" do
          cashmutation_count = CashMutation.where(
            :source_class => @pv.class.to_s, 
            :source_id => @pv.id 
          ).count
          
          cashmutation_count.should == 2
        end
        
        it "should update each payable.remaining_amount to 0" do
          @payable.first.remaining_amount.should == 0
          @payable2.first.remaining_amount.should == 0
        end
        
        it "allow unconfirm payment_request" do
          @pv.unconfirm_object
          @pv.errors.size.should == 0
        end
        
        context "unconfirm payment_request" do
          before(:each) do
            @pv.unconfirm_object
            @cb.reload
            @payable.reload
            @payable2.reload
          end
          
          it "should update cashbank amount to 90000" do
            @cb.amount.should == BigDecimal("90000")
          end

          it "should delete 2 cash mutation" do
            cashmutation_count = CashMutation.where(
              :source_class => @pv.class.to_s, 
              :source_id => @pv.id ,
            ).count

            cashmutation_count.should == 0
          end

          it "should update each payable.remaining_amount to first amount" do
            @payable.first.remaining_amount.should ==  @initial_payable_amount
            @payable2.first.remaining_amount.should ==  @initial_payable2_amount
          end

          it "cannot unconfirm payment_request" do
            @pv.unconfirm_object
            @pv.errors.size.should_not == 0
          end
          
          
        end
      end
      
    end
  end
end
