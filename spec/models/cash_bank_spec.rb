require 'spec_helper'

describe CashBank do
  before(:each) do
    @name_1 = "jojo_bca"
    @name_2 = "jojo_mandiri"
  end
  
  it "should be allowed to create cb" do
    cb = CashBank.create_object(
      :name => @name_1,
      :description => "ehaufeahifi heaw",
      :is_bank => true
      
      )
    
    cb.should be_valid
    cb.errors.size.should == 0 
  end
  
  it "should create object without name" do
    cb = CashBank.create_object(
      :name => nil ,
      :description => "ehaufeahifi heaw",
      :is_bank => true
      
      )
    
    cb.errors.size.should_not == 0 
    cb.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    cb = CashBank.create_object(
      :name => "" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true
      
      )
    
    cb.errors.size.should_not == 0 
    cb.should_not be_valid
    
  end
  
  context "create duplicate objet is not allowed" do
    before(:each) do 
      @cb_1 = CashBank.create_object(
        :name => @name_1,
        :description => "ehaufeahifi heaw",
        :is_bank => true
      )
    end
    
    it "should not be allowed to create another cb with same name" do
      @cb_2 = CashBank.create_object(
        :name => @name_1,
        :description => "ehaufeahifi heaw",
        :is_bank => true
      )
      
      @cb_2.errors.size.should_not == 0 
      @cb_2.should_not be_valid
    end
    
    context "can't update object that will dis validate the uniqueness contraint" do
      before(:each) do
        @cb_2 = CashBank.create_object(
          :name => @name_2,
          :description => "ehaufeahifi heaw",
          :is_bank => true
        )
      end
      
      it "should have valid cb2 and valid cb1" do
        @cb_2.should be_valid
        @cb_1.should be_valid
      end
      
      it "should not allow update with duplicate name" do
        @cb_2.update_object(
            :name => @name_1,
            :description => "ehaufeahifi heaw",
            :is_bank => true
          )
        
        @cb_2.errors.size.should_not == 0 
        
      end
    end
  end
  
end
