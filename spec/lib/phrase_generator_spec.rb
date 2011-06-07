require "spec_helper"

describe "PhraseGenerator" do
  
  context "when generating a new phrase" do
    it "should generate a phrase with the correct number of words without duplicates" do
      phrase = PhraseGenerator.generate(3, %w{apple banana orange})
      
      phrase.count("/").should == 2
      phrase.split("/").should =~ %w{apple banana orange}
    end
  end
  
  context "when creating a pattern from a phrase" do
    it "should replace the letters with an underscore" do
      pattern = PhraseGenerator.patternize("this/is/my/phrase")
      pattern.should == "____/__/__/______"
    end
  end
  
end