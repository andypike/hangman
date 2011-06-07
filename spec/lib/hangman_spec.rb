require "spec_helper"

describe "Hangman" do
  
  context "when starting up a new game" do
    before(:each) do
      @renderer = double("Renderer")
      @dictionary_loader = double("DictionaryLoader")
      @player_loader = double("PlayerLoader")
      @user_input = double("ConsoleUserInput")
      @new_game = double("Game")

      @renderer.stub(:welcome)
      @renderer.stub(:errors)
      @renderer.stub(:players_list)
      @dictionary_loader.stub(:load) { %w{apple bear cat} }
      @player_loader.stub(:load)
      @player_loader.stub(:errors)
      @user_input.stub(:select_players)
      @user_input.stub(:select_num_of_words)
      @new_game.stub(:start)
      Game.stub(:new) { @new_game }
      
      @hangman = Hangman.new(@renderer, @dictionary_loader, @player_loader, @user_input)      
    end
    
    it "should output a welcome message" do
      @renderer.should_receive(:welcome)
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
      @renderer.should_receive(:players_list).with(players)
      @hangman.start
    end
    
    it "should render the list of errors while trying to load players" do
      errors = []
      @player_loader.stub(:errors) { errors }
      @renderer.should_receive(:errors).with(errors)
      @hangman.start
    end
    
    it "should allow the user to select 2 players" do
      players = []
      @player_loader.stub(:load) { players }
      @user_input.should_receive(:select_players).with(2, players)
      @hangman.start
    end
    
    it "should allow the user to select the number of words per phrase" do
      @user_input.should_receive(:select_num_of_words)
      @hangman.start
    end
    
    it "should create a new game" do
      Game.should_receive(:new).with(%w{apple bear cat}).and_return(@new_game)
      
      @hangman.start
    end
    
    it "should start the newly created game" do
      @user_input.stub(:select_num_of_words) { 5 }
      @user_input.stub(:select_players) { [] }
      
      @new_game.should_receive(:start).with(5, [])
      
      @hangman.start
    end
  end
  
end