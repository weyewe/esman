require 'spec_helper'

describe HomeType do
  
  before (:each) do
    @name_1 = "type1"
    @name_2 = "type2"
    @description_1 = "description_1"
    @description_2 = "description_2"
    @amount1 = BigDecimal("50000")
    @amount2 = BigDecimal("25000")
  end
  
  it "should be allowed to create HomeType_type" do
    hmt = HomeType.create_object(
      :name => @name_1,
      :description => @description_1,
      :amount => @amount1
    )
    
    hmt.should be_valid
    hmt.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    hmt = HomeType.create_object(
      :name => nil ,
      :description => @description_1,
      :amount => @amount1,
      )
    
    hmt.errors.size.should_not == 0 
    hmt.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    hmt = HomeType.create_object(
       :name => "" ,
       :description => @description_1,
       :amount => @amount1,
    )
    
    hmt.errors.size.should_not == 0 
    hmt.should_not be_valid
    
  end
  
  context "Create New HomeType" do
    before (:each) do
      @hmt = HomeType.create_object(
        :name => @name_1 ,
        :description => @description_1,
        :amount => @amount1,
      )
    end
    
    it "should create HomeType" do
      @hmt.errors.size.should == 0
      @hmt.should be_valid
    end
    
    it "cannot update object if name not valid" do
     @hmt.update_object(
        :name => nil,
        :description => @description_2,
        :amount => @amount2,
     )
     @hmt.errors.size.should_not == 0 
     @hmt.should_not be_valid
    end
    
    it "cannot update object if amount not valid" do
     @hmt.update_object(
        :name => @name_2,
        :description => @description_2,
        :amount => nil,
     )
     @hmt.errors.size.should_not == 0 
     @hmt.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @hmt.update_object(
       :name => "",
       :description => @description_2,
       :amount => @amount2,
     )
     @hmt.errors.size.should_not == 0 
     @hmt.should_not be_valid
    end
    
    it "should update object" do
       @hmt.update_object(
         :name => @name_2 ,
         :description => @description_2,
         :amount => @amount2,
       )
       @hmt.name.should == @name_2
       @hmt.description.should == @description_2
       @hmt.amount.should == @amount2
    end
  
  end
  
  
end
