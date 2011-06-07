require "spec_helper"

describe "Game" do
  
  context "when starting up a new game" do
    before(:each) do
      @game = Game.new %w{apple bear cat}
    end
    
    it "should generate a new phrase with the correct number of words from the word list passed in" do
      PhraseGenerator.should_receive(:generate).with(5, %w{apple bear cat})
      @game.start(5, [])
    end
  end
  
end