require "spec_helper"

describe "Hangman" do
  
  context "when starting up a new game" do
    before(:each) do
      @dictionary_loader = double("DictionaryLoader")
      @player_loader = double("PlayerLoader")

      @dictionary_loader.stub(:load){ %w{apple bear cat} }
      @player_loader.stub(:load)
      
      @hangman = Hangman.new(@dictionary_loader, @player_loader)      
    end
    
    it "should output a welcome message" do
      should_puts "Welcome to Hangman"
      @hangman.start 
    end
    
    it "should load a dictionary of words" do
      @dictionary_loader.should_receive(:load).with('dictionary.txt').and_return(%w{apple bear cat})
      @hangman.start 
    end
    
    it "should load all players" do
      @player_loader.should_receive(:load).with('players').and_return([])
      @hangman.start
    end
  end
  
end