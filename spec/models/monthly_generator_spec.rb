require 'spec_helper'

describe MonthlyGenerator do
  
  before (:each) do 
    @generated_date = DateTime.now
    @desription = "description"  
    @home_type = HomeType.create_object(
      :name => "Type1",
      :description => "description1",
      :amount => "50000"
      )
    @home_type2 = HomeType.create_object(
      :name => "Type1",
      :description => "description1",
      :amount => "25000"
      )
    @hm = Home.create_object(
      :name => "HomeName",
      :address => "HomeAddress",
      :home_type_id => @home_type.id
    ) 
    @hm2 = Home.create_object(
      :name => "HomeName2",
      :address => "HomeAddress2",
      :home_type_id => @home_type2.id
    ) 
  end
 
  it "should create Home" do
    @hm.errors.size.should == 0
    @hm.should be_valid
  end
  
  it "should create monthly_generator" do
    mtg = MonthlyGenerator.create_object(
      :generated_date => @generated_date,
      :description => @description
    )
    mtg.errors.size.should == 0
    mtg.should be_valid
  end
  
  
  it "cannot create if generated_date is not valid" do
    mtg = MonthlyGenerator.create_object(
      :generated_date => nil,
      :description => @description,
    )
    mtg.errors.size.should_not == 0
    mtg.should_not be_valid
  end
  
  context "created monthly_generator" do
    before(:each) do
      @new_generated_date = @generated_date + 1.days
      @new_description = "asdasdasdwe"
      @mtg = MonthlyGenerator.create_object(
        :generated_date => @generated_date,
        :description => @description,
      )
    end
   
    
    it "should create monthly_generator" do
      @mtg.errors.size.should == 0
      @mtg.should be_valid
    end
    
    it "should update monthly_generator" do
      @mtg.update_object(
        :generated_date => @new_generated_date,
        :description => @new_description,
      )
      @mtg.errors.size.should == 0
      @mtg.should be_valid
      @mtg.generated_date.should == @new_generated_date
      @mtg.description.should == @new_description
    end
    
    it "should not update monthly_generator if generated_date not valid" do
      @mtg.update_object(
        :generated_date => nil,
        :description => @new_description,
      )
      @mtg.errors.size.should_not == 0
      @mtg.should_not be_valid
     end     
    
    it "should confirm monthly_generator" do
      @mtg.confirm_object(:confirmed_at => DateTime.now)
      @mtg.errors.size.should == 0
      @mtg.should be_valid
      @mtg.is_confirmed.should be_true
    end
    
    context "Confirm monthly_generator" do
      before(:each) do
        @mtg.confirm_object(:confirmed_at => DateTime.now)
      endrails
      
      it "should confirm monthly_generator" do
        @mtg.errors.size.should == 0
        @mtg.should be_valid
        @mtg.is_confirmed.should be_true
      end
      
      it "should unconfirm monthly_generator" do
        @mtg.unconfirm_object 
        @mtg.errors.size.should == 0
        @mtg.is_confirmed.should be_false
      end
      
      it "should not confirm monthly_generator if already confirmed" do
        @mtg.confirm_object(:confirmed_at => DateTime.now)
        @mtg.errors.size.should_not == 0
      end
      
      it "should run generate_invoice if already confirmed and 
          create 2 invoice and 2 receivable because 2 created 2 home" do
        invoice_count = Invoice.where(
          :source_id => @mtg.id,
          :source_class => @mtg.class.to_s,
          :invoice_date => @mtg.generated_date,
          :description => @mtg.description
        ).count
        receivable_count = Receivable.count
        @mtg.errors.size.should == 0
        invoice_count.should == 2
        receivable_count.should == 2
      end
      
    end
    
  end
end 
end
