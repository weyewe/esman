require 'spec_helper'

describe Vendor do
   before (:each) do
    @name_1 = "vendor1"
    @name_2 = "vendor2"
    @address_1 = "address1"
    @address_2 = "address2"
    @description_1 = "description1"
    @description_2 = "description2"
   
  end
  
  it "should be allowed to create vendor" do
    vd = Vendor.create_object(
      :name => @name_1,
      :address => @address_1,
      :description => @description_1
    )
    
    vd.should be_valid
    vd.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    vd = Vendor.create_object(
      :name => nil ,
      :address => @address_1,
      :description => @description_1
      )
    
    vd.errors.size.should_not == 0 
    vd.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    vd = Vendor.create_object(
       :name => "" ,
       :address => @address_1,
       :description => @description_1
    )
    
    vd.errors.size.should_not == 0 
    vd.should_not be_valid
    
  end
  
  
  context "Create New Vendor" do
    before (:each) do
      @vd = Vendor.create_object(
        :name => @name_1 ,
        :address => @address_1,
        :description => @description_1
      )
    end
    
    it "should create vendor" do
      @vd.errors.size.should == 0
      @vd.should be_valid
    end
    
    it "cannot update object if name not valid" do
     @vd.update_object(
        :name => nil,
        :address => @address_2,
        :description => @description_1
     )
     @vd.errors.size.should_not == 0 
     @vd.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @vd.update_object(
       :name => "",
       :address => @address_2,
       :description => @description_1
     )
     @vd.errors.size.should_not == 0 
     @vd.should_not be_valid
    end   
    
    it "should update object" do
       @vd.update_object(
         :name => @name_2 ,
         :address => @address_2,
         :description => @description_2
       )
       @vd.name.should == @name_2
       @vd.address.should == @address_2
       @vd.description.should == @description_2
    end
  
  end
end
