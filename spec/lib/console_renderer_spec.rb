require "spec_helper"

describe "Renderer" do
  before(:each) do
    @renderer = ConsoleRenderer.new
  end
  
  context "when writing adhoc text to the terminal" do
    it "should output using stdout puts" do      
      $stdout.should_receive(:puts).with("Hello World")
      
      @renderer.output "Hello World"
    end
  end
  
  context "when rendering the welcome message" do
    it "should output using stdout puts" do      
      @renderer.stub(:clear)
      @renderer.stub(:output)
      @renderer.stub(:blank_line)
      @renderer.should_receive(:output).with("Welcome to Hangman")
      
      @renderer.welcome
    end
  end
  
  context "when rendering the list of loaded players" do
    before(:each) do
      @renderer.stub(:output)
    end
    
    it "should output each player name" do 
      @renderer.should_receive(:output).with("1: Andy's Awesome Player")
      @renderer.should_receive(:output).with("2: Another cool Player")
      
      @renderer.players_list([FakePlayer1, FakePlayer2])
    end
    
    it "should output a nice message if there are no players" do 
      @renderer.should_receive(:output).with("* No players loaded :o(")
      
      @renderer.players_list([])
    end
  end
  
  context "when rendering the list of errors" do
    before(:each) do
      @renderer.stub(:output)
    end
    
    it "should output each error" do 
      @renderer.should_receive(:output).with("* This is the first error")
      @renderer.should_receive(:output).with("* This is the second error")
      
      @renderer.errors(["This is the first error", "This is the second error"])
    end
    
    it "should output a nice message if there are no errors" do 
      @renderer.should_receive(:output).with("* No errors to report :o)")
      
      @renderer.errors([])
    end
  end
  
  context "when rendering a game loop frame" do
    before(:each) do
      @player = FakePlayer1.new 
      @player_state = PlayerState.new(@player, "___/___/___")
      @states = [@player_state]
      @renderer.stub(:output)
    end
    
    it "should clear the screen" do
      @renderer.should_receive(:clear)
      
      @renderer.game_frame([])
    end
    
    it "for each player state it should render their name" do
      @renderer.should_receive(:output).with("Andy's Awesome Player")
      
      @renderer.game_frame(@states)
    end
    
    it "for each player state it should render the state of their current pattern" do
      @renderer.should_receive(:output).with("___/___/___")
      
      @renderer.game_frame(@states)
    end
    
    it "for each player state it should render the list of correct guesses so far" do
      @player_state.stub(:correct_guesses) { ["a", "b", "c"] }
      @renderer.should_receive(:output).with("Correct: a b c")
      
      @renderer.game_frame(@states)
    end
    
    it "for each player state it should render the list of incorrect guesses so far" do
      @player_state.stub(:incorrect_guesses) { ["x", "y", "z"] }
      @renderer.should_receive(:output).with("Incorrect: x y z")
      
      @renderer.game_frame(@states)
    end
    
    it "for each player state it should render the gallows at the stage based on the number of incorrect guesses" do
      @player_state.stub(:incorrect_guesses) { ["x", "y", "z"] }
      Gallows.stub(:stages) { ["stage 1", "stage 2", "stage 3", "stage 4", "stage 5"] }
      @renderer.should_receive(:output).with("stage 3")
      
      @renderer.game_frame(@states)
    end
  end
end

class FakePlayer1
  def name
    "Andy's Awesome Player"
  end
end

class FakePlayer2
  def name
    "Another cool Player"
  end
end