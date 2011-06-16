require "spec_helper"

describe "PlayerState" do
  before(:each) do
    @phrase = "abc/xyz/abc"
    @pattern = "___/___/___"
    @player = FakePlayerForProcessingGuess.new
    @state = PlayerState.new(@player, @pattern)
  end
  
  context "processing a turn taken by a player" do
    it "should lowercase and find if the guess is within the phrase" do
      @phrase.should_receive(:all_indices).with("a").and_return([])
      @state.turn_taken("a", @phrase)
    end
    
    it "should record any incorrect guesses" do
      @phrase.stub(:all_indices).and_return([])
      @state.turn_taken("a", @phrase)
      @state.incorrect_guesses.should == ["a"]
    end
    
    it "should record any correct guesses" do
      @phrase.stub(:all_indices).and_return([0])
      @state.turn_taken("b", @phrase)
      @state.correct_guesses.should == ["b"]
    end
    
    it "should update the player's pattern with any correctly matching single chars" do
      @phrase.stub(:all_indices).and_return([0, 8])
      @state.turn_taken("a", @phrase)
      @state.current_pattern.should == "a__/___/a__"
    end
    
    it "should update the player's pattern with any correctly matching words" do
      @phrase.stub(:all_indices).and_return([0, 8])
      @state.turn_taken("abc", @phrase)
      @state.current_pattern.should == "abc/___/abc"
    end
    
    it "should not update the player's pattern with any start of a whole word" do
      @phrase.stub(:all_indices).and_return([0, 8])
      @state.turn_taken("ab", @phrase)
      @state.current_pattern.should == "___/___/___"
    end
    
    it "should not update the player's pattern with any end of a whole word" do
      @phrase.stub(:all_indices).and_return([1, 9])
      @state.turn_taken("bc", @phrase)
      @state.current_pattern.should == "___/___/___"
    end
    
    it "should not update the player's pattern with any part of a whole word" do
      @phrase.stub(:all_indices).and_return([4])
      @state.current_pattern = "_____________"
      @state.turn_taken("isaph", "thisisaphrase")
      @state.current_pattern.should == "_____________"
    end
    
    it "should update the player's pattern with a correctly matching whole phrase" do
      @phrase.stub(:all_indices).and_return([0])
      @state.turn_taken("abc/xyz/abc", @phrase)
      @state.current_pattern.should == "abc/xyz/abc"
    end
    
    it "should report true if the phrase has been found if no letters are missing" do
      @phrase.stub(:all_indices).and_return([0])
      @state.turn_taken("abc/xyz/abc", @phrase)
      @state.found_phrase.should be_true
    end
    
    it "should report false if the phrase still has missing letters" do
      @phrase.stub(:all_indices).and_return([0])
      @state.turn_taken("a", @phrase)
      @state.found_phrase.should be_false
    end
    
    it "should treat a nil guess as incorrect" do
      @phrase.stub(:all_indices).and_return([])
      @state.turn_taken(nil, @phrase)
      @state.incorrect_guesses.should == ["[nil]"]
    end
    
    it "should treat a non string guess as incorrect" do
      @phrase.stub(:all_indices).and_return([])
      @state.turn_taken(Object.new, @phrase)
      @state.incorrect_guesses.should == ["[invalid]"]
    end
    
    it "should treat an empty string guess as incorrect" do
      @phrase.stub(:all_indices).and_return([])
      @state.turn_taken("", @phrase)
      @state.incorrect_guesses.should == ["[empty]"]
    end
  end
end

class FakePlayerForProcessingGuess
  def name
    "My Player"
  end
end