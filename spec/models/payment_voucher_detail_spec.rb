require 'spec_helper'

describe PaymentVoucherDetail do
  before(:each) do
    @vd = Vendor.create_object(
      :name => "vendor1",
      :address => "address_1",
      :description => "description_1"
    )
    
    @cb = CashBank.create_object(
      :name => "awesome name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true 
    )
    
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
    
    @pv = PaymentVoucher.create_object(
      :description => "pv desc",
      :payment_date => DateTime.now,
      :vendor_id => @vd.id,
      :cash_bank_id => @cb.id
      )  
  end
  
  it "should create payment_voucher_detail" do
    pvd = PaymentVoucherDetail.create_object(
      :payment_voucher_id => @pv.id,
       :payable_id => @payable.first.id
      )
    pvd.errors.size.should == 0
    pvd.should be_valid
  end
  
  context "create payment_voucher_detail" do
    before(:each) do
      @pvd = PaymentVoucherDetail.create_object(
       :payment_voucher_id => @pv.id,
       :payable_id => @payable.first.id
      )
    end
    
    it "should create payment_voucher_detail" do
      @pvd.errors.size.should == 0
      @pvd.should be_valid
    end
    
    it "should update payment_voucher_detail" do
      @pvd.update_object(
        :payment_voucher_id => @pv.id,
        :payable_id => @payable2.first.id
        )
      @pvd.errors.size.should == 0
      @pvd.should be_valid
      @pvd.payable_id.should == @payable2.first.id
    end
    
    it "cannot update payment_voucher_detail if payable not valid" do
      @pvd.update_object(
        :payment_voucher_id => @pv.id,
        :payable_id => 2424
        )
      @pvd.errors.size.should_not == 0
      @pvd.should_not be_valid
    end
    
    it "should delete payment_voucher_detail" do
      @pvd.delete_object
      @pvd.is_deleted == be_true
    end
    
    it "cannot create payment_voucher_detail with same payable" do
      pvd2 = PaymentVoucherDetail.create_object(
       :payment_voucher_id => @pv.id,
       :payable_id => @payable.first.id
      )
      pvd2.errors.size.should_not == 0
      pvd2.should_not be_valid
    end
    
    context "Confirm payment_voucher" do
      before(:each) do
        @pv.confirm_object(:confirmed_at => DateTime.now)
      end
      
      it "cannot delete payment_voucher_detail if alreadry confirmed" do
        @pvd.delete_object
        @pvd.errors.size.should_not == 0
      end
      
      it "cannot update payment_voucher_detail if alreadry confirmed" do
        @pvd.update_object(
          :payment_voucher_id => @pv.id,
          :payable_id => @payable2.first.id
          )
        @pvd.errors.size.should_not == 0
      end
      
    end
  end
  
end
