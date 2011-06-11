require "spec_helper"

describe "String" do
  
  context "when searching for a string within a string" do
    it "should return all indices of a single char that appears multiple times" do      
      "andy/amber/megan".all_indices("a").should == [0, 5, 14]
    end
    
    it "should not return any indices if the single char doesn't exist'" do      
      "andy/amber/megan".all_indices("x").should == []
    end
    
    it "should return all indices of a single char that appears multiple times" do      
      "andy/amber/megan".all_indices("an").should == [0, 14]
    end
  end

end