require "spec_helper"

describe "Hangman" do
  
  context "when starting up a new game" do
    before(:each) do
      @hangman = Hangman.new      
    end
    
    it "should output a welcome message" do
      $stdout.should_receive(:puts).with("Welcome to Hangman")
      @hangman.start 
    end
  end
  
end