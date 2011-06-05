require "spec_helper"

describe "PlayerLoader" do
  
  before(:each) do
    @player_loader = PlayerLoader.new
  end

  context "when loading invalid players" do
    it "should return an empty list of loaded players" do
      players = @player_loader.load("spec/data/invalid_players")
      
      players.empty?.should be_true
      @player_loader.errors.size.should == 4
      @player_loader.errors[0].should =~ /^Failed to load player 'spec\/data\/invalid_players\/player4.rb' due to a syntax error:/
      @player_loader.errors[1].should =~ /^Failed to load player 'InvalidNoNameDefinedPlayer' because it doesn't contain the method: name$/
      @player_loader.errors[2].should =~ /^Failed to load player 'InvalidNoNewGameDefinedPlayer' because it doesn't contain the method: new_game$/
      @player_loader.errors[3].should =~ /^Failed to load player 'InvalidNoTakeTurnDefinedPlayer' because it doesn't contain the method: take_turn$/
    end
  end

  context "when loading valid players" do    
    it "should require all ruby files in the players folder" do
      @player_loader.should_receive(:require_player_file).with("spec/data/valid_players/player1.rb")
      @player_loader.should_receive(:require_player_file).with("spec/data/valid_players/player2.rb")
      @player_loader.load("spec/data/valid_players")
    end
    
    it "should return a list of loaded players" do
      players = @player_loader.load("spec/data/valid_players")
      
      players.should =~ [ValidTest1Player, ValidTest2Player]
    end
  end
end