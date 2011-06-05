require "spec_helper"

describe "Hangman" do
  
  context "when starting up a new game" do
    before(:each) do
      @renderer = double("Renderer")
      @dictionary_loader = double("DictionaryLoader")
      @player_loader = double("PlayerLoader")

      @renderer.stub(:output)
      @renderer.stub(:render_players)
      @renderer.stub(:clear)
      @renderer.stub(:blank_line)
      @dictionary_loader.stub(:load){ %w{apple bear cat} }
      @player_loader.stub(:load)
      
      @hangman = Hangman.new(@renderer, @dictionary_loader, @player_loader)      
    end
    
    it "should clear the screen" do
      @renderer.should_receive(:clear)
      @hangman.start      
    end
    
    it "should output a welcome message" do
      @renderer.should_receive(:output).with("Welcome to Hangman")
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
    
    it "should render the list of loaded players" do
      players = []
      @player_loader.stub(:load) { players }
      @renderer.should_receive(:render_players).with(players)
      @hangman.start
    end
  end
  
end