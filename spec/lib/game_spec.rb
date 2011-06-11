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
      PhraseGenerator.stub(:patternize) { @pattern }
      @player1.stub(:new_game)
      @player2.stub(:new_game)
      @renderer.stub(:game_frame)
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
      }
      
      @game.start(3, [@player1])
    end
    
    it "should render the game loop frame" do
      @renderer.should_receive(:game_frame)
      @game.start(3, [@player1])
    end
  end
  
end
