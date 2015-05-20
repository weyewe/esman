require 'spec_helper'

describe Home do
  
  before (:each) do
    @name_1 = "home1"
    @name_2 = "home2"
    @address_1 = "address1"
    @address_2 = "address2"
    
    @home_type1 = HomeType.create_object(
      :name => "Type1",
      :description => "description1",
      :amount => "50000"
      )
    
    @home_type2 = HomeType.create_object(
      :name => "Type2",
      :description => "description2",
      :amount => "25000"
      )
  end
  
  it "should be allowed to create home" do
    hm = Home.create_object(
      :name => @name_1,
      :address => @address_1,
      :home_type_id => @home_type1.id
    )
    
    hm.should be_valid
    hm.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    hm = Home.create_object(
      :name => nil ,
      :address => @address_1,
      :home_type_id => @home_type1.id
      )
    
    hm.errors.size.should_not == 0 
    hm.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    hm = Home.create_object(
       :name => "" ,
       :address => @address_1,
       :home_type_id => @home_type1.id
    )
    
    hm.errors.size.should_not == 0 
    hm.should_not be_valid
    
  end
  
  it "should not create object without address" do
    hm = Home.create_object(
        :name => @name_1 ,
        :address => nil,
        :home_type_id => @home_type1.id
    )
    
    hm.errors.size.should_not == 0 
    hm.should_not be_valid
    
  end
  
  it "should not create object if addrss present, but length == 0 " do
    hm = Home.create_object(
       :name => @name_1 ,
       :address => nil,
       :home_type_id => @home_type1.id
    )
    
    hm.errors.size.should_not == 0 
    hm.should_not be_valid
    
  end
  
  it "should not create if home_type_id is not valid" do
   hm = Home.create_object(
         :name => @name_1 ,
         :address => nil,
         :home_type_id => 10
   )
  end
  
  
  context "Create New Home" do
    before (:each) do
      @hm = Home.create_object(
        :name => @name_1 ,
        :address => @address_1,
        :home_type_id => @home_type1.id
      )
    end
    
    it "should create home" do
      @hm.errors.size.should == 0
      @hm.should be_valid
    end
    
    it "cannot update object if name not valid" do
     @hm.update_object(
        :name => nil,
        :address => @address_2,
        :home_type_id => @home_type1.id
     )
     @hm.errors.size.should_not == 0 
     @hm.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @hm.update_object(
       :name => "",
       :address => @address_2,
       :home_type_id => @home_type1.id
     )
     @hm.errors.size.should_not == 0 
     @hm.should_not be_valid
    end
    
    it "cannot update object if address not valid" do
       @hm.update_object(
        :name => @name_1,
        :address => nil,
        :home_type_id => @home_type1.id
       )
       @hm.errors.size.should_not == 0 
       @hm.should_not be_valid
    end
    
    it "cannot update object if address present, but lenght == 0" do
       @hm.update_object(
         :name => @name_1,
         :address => "" ,
         :home_type_id => @home_type1.id
       )
       @hm.errors.size.should_not == 0 
       @hm.should_not be_valid
    end
    
    it "cannot update if home_type_id is not valid" do
       hm = Home.create_object(
          :name => @name_1 ,
          :address => @address2,
          :home_type_id => 10
       )
    end
    
    it "should update object" do
       @hm.update_object(
         :name => @name_2 ,
         :address => @address_2,
         :home_type_id => @home_type2.id
       )
       @hm.name.should == @name_2
       @hm.address.should == @address_2
       @hm.home_type_id == @home_type2.id
    end
  
  end
  
  
end
