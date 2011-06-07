require "spec_helper"

describe "Gallows" do
  
  context "when storing the stages of the gallows" do
    it "should return a string array with 12 stages" do
      Gallows.stages.size.should == 12
    end
  end
  
end