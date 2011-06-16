require "spec_helper"

describe "GameAnalyser" do
  
  context "when analysing the game to decide if it is over" do
    before :each do
      @player1 = double("FakePlayerForAnalyser1")
      @player2 = double("FakePlayerForAnalyser2")
      @player1.stub(:name) { "Player 1" }
      @player2.stub(:name) { "Player 2" }
      @pattern = "___/___/___"
      @states = [PlayerState.new(@player1, @pattern), PlayerState.new(@player2, @pattern)]
      @renderer = double("ConsoleRenderer")
      @analyser = GameAnalyser.new(@states, @renderer)
      @renderer.stub(:output)
    end
    
    it "should return true if one player has found the phrase" do
      @states[0].stub(:found_phrase) { true }
      @analyser.game_over?.should be_true
    end
    
    it "should return false if no players have found the phrase and there are no dead players" do
      @states[0].stub(:found_phrase) { false }
      @states[1].stub(:found_phrase) { false }
      @states[0].stub(:incorrect_guesses) { [] }
      @states[1].stub(:incorrect_guesses) { [] }
      
      @analyser.game_over?.should be_false
    end
    
    it "should display a winning message if one player has found the phrase" do
      @states[0].stub(:found_phrase) { true }
      @renderer.should_receive(:output).with("We have a winner! Player 1 found the phrase!")
      @analyser.game_over?
    end
    
    it "should return true if multiple players have found the phrase" do
      @states[0].stub(:found_phrase) { true }
      @states[1].stub(:found_phrase) { true }
      @analyser.game_over?.should be_true
    end
    
    it "should display a drawing message if multiple players have found the phrase" do
      @states[0].stub(:found_phrase) { true }
      @states[1].stub(:found_phrase) { true }
      @renderer.should_receive(:output).with("We have a draw between Player 1 and Player 2")
      @analyser.game_over?
    end
    
    it "should return true if one player is dead" do
      @states[0].stub(:incorrect_guesses) { %w"a b c d e f g h i j k l m n o p" }
      @analyser.game_over?.should be_true
    end
    
    it "should display a 'dead' message if one player is hung" do
      @states[0].stub(:incorrect_guesses) { %w"a b c d e f g h i j k l m n o p" }
      @renderer.should_receive(:output).with("Player 1 is dead.")
      @analyser.game_over?
    end
    
    it "should display a winning message if one player is hung" do
      @states[0].stub(:incorrect_guesses) { %w"a b c d e f g h i j k l m n o p" }
      @renderer.should_receive(:output).with("We have a winner! Player 2 survived longer!")
      @analyser.game_over?
    end
    
    it "should display a message if all players are hung" do
      @states[0].stub(:incorrect_guesses) { %w"a b c d e f g h i j k l m n o p" }
      @states[1].stub(:incorrect_guesses) { %w"a b c d e f g h i j k l m n o p" }
      @renderer.should_receive(:output).with("It's a draw, all players are dead.")
      @analyser.game_over?
    end
  end
  
end