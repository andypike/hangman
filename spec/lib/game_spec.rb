require "spec_helper"

describe "Game" do
  
  context "when starting up a new game" do
    before(:each) do
      @word_list = %w{apple bear cat}
      @renderer = double("ConsoleRenderer")
      
      @game = Game.new @word_list, @renderer

      @player1 = double("FakePlayerForNewGame1")
      @player2 = double("FakePlayerForNewGame2")
      @pattern = "___/____/___"
      PhraseGenerator.stub(:generate) { "abc/def/ghi" }
      PhraseGenerator.stub(:patternize) { @pattern }
      @player1.stub(:new_game)
      @player2.stub(:new_game)
      @renderer.stub(:game_frame)
      @player1.stub(:take_turn) { "x" }
      @player2.stub(:take_turn) { "x" }
      @player_state = double("PlayerState")
      @player_state.stub(:player) { @player1 }
      @player_state.stub(:current_pattern) { "___/____/___" }
      @player_state.stub(:turn_taken)
      PlayerState.stub(:new) { @player_state }
      @game.stub(:pause)
      @analyzer = double("GameAnalyser")
      GameAnalyser.stub(:new) { @analyzer }
      @analyzer.stub(:game_over?) { true }
    end
    
    it "should generate a new phrase with the correct number of words from the word list passed in" do
      PhraseGenerator.should_receive(:generate).with(5, %w{apple bear cat})
      @game.start(5, [])
    end
    
    it "should convert the generated phrase into a pattern" do
      PhraseGenerator.stub(:generate) { "this/is/a/phrase" }
      PhraseGenerator.should_receive(:patternize).with("this/is/a/phrase")
      @game.start(5, [])
    end
    
    it "should call new_game for each player passing a copy of the word list" do      
      @player1.should_receive(:new_game) { |word_list|
        word_list.object_id.should_not == @word_list.object_id  # not the same object
        word_list.should == @word_list                          # but contains the same elements
      }
      @player2.should_receive(:new_game) { |word_list|
        word_list.object_id.should_not == @word_list.object_id
        word_list.should == @word_list
      }
      
      @game.start(3, [@player1, @player2])
    end
    
    it "should create a player state for each player" do
      PlayerState.should_receive(:new) { |player, pattern|
        player.should == @player1
        pattern.object_id.should_not == @pattern.object_id
        pattern.should == @pattern
        @player_state
      }
      
      @game.start(3, [@player1])
    end
    
    it "should render the game loop frame" do
      @renderer.should_receive(:game_frame)
      @game.start(3, [@player1])
    end
    
    it "should allow each player to take a turn passing a copy of their current pattern" do
      @player1.should_receive(:take_turn).with(@pattern)
      @game.start(3, [@player1])
    end
    
    it "should allow the player state to update after the turn was taken" do
      @player1.stub(:take_turn) { "A" }
      @player_state.should_receive(:turn_taken).with("a", "abc/def/ghi")
      @game.start(3, [@player1])      
    end
    
    it "should render the current game frame" do
      @renderer.should_receive(:game_frame).twice
      @game.start(3, [@player1])            
    end
    
    it "should create a game analyser" do
      GameAnalyser.should_receive(:new).and_return(@analyzer)
      @game.start(3, [@player1])           
    end
    
    it "should use the game analyser to determine if the game has finished" do
      @analyzer.should_receive(:game_over?).and_return(true)
      @game.start(3, [@player1])           
    end
  end
  
end
