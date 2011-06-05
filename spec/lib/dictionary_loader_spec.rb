require "spec_helper"

describe "DictionaryLoader" do
  
  context "when loading a word list from file" do
    before(:each) do
      @dictionary_loader = DictionaryLoader.new
    end
    
    it "should output a welcome message" do      
      words = @dictionary_loader.load("spec/data/test_dictionary.txt")
      
      words.should == ["apple", "bear", "cat"]
    end
  end
  
end

