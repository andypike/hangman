require "spec_helper"

describe "ConsoleUserInput" do
  before(:each) do
    @renderer = double("Renderer")
    @user_input = ConsoleUserInput.new(@renderer)
  end
  
  context "when the user enters a number" do
    it "should return the number entered as an integer" do
      @user_input.stub(:gets) { "5\n" }
      @user_input.read_number.should == 5
    end
    
    it "should handle non-integer input" do
      @user_input.stub(:gets) { "This is not a number\n" }
      @user_input.read_number.should == 0
    end
  end
  
  context "when the user is selecting the players" do
    before(:each) do
      @renderer.stub(:output)
    end
    
    it "should prompt the user for each player" do     
      @user_input.stub(:read_number) { 1 }
      @renderer.should_receive(:output).with("Please select player 1:")
      @renderer.should_receive(:output).with("Please select player 2:")
      
      @user_input.select_players(2, [FakePlayer3, FakePlayer4])
    end
    
    it "should instantiate return the selected players" do
      @user_input.should_receive(:read_number).once.ordered.and_return(2)
      @user_input.should_receive(:read_number).once.ordered.and_return(4)
      
      players = @user_input.select_players(2, [FakePlayer3, FakePlayer4, FakePlayer5, FakePlayer6])
      players.size.should == 2
      players[0].class.should == FakePlayer4
      players[1].class.should == FakePlayer6
    end
    
    it "should handle a number entry out of range (<= 0)" do
      @user_input.should_receive(:read_number).once.ordered.and_return(0)
      @user_input.should_receive(:read_number).once.ordered.and_return(3)
      @renderer.should_receive(:output).with("You must enter a valid player number, please try again:")
      
      players = @user_input.select_players(1, [FakePlayer3, FakePlayer4, FakePlayer5, FakePlayer6])
      players[0].class.should == FakePlayer5
    end
    
    it "should handle a number entry out of range (> number of players)" do
      @user_input.should_receive(:read_number).once.ordered.and_return(10)
      @user_input.should_receive(:read_number).once.ordered.and_return(3)
      @renderer.should_receive(:output).with("You must enter a valid player number, please try again:")
      
      players = @user_input.select_players(1, [FakePlayer3, FakePlayer4, FakePlayer5, FakePlayer6])
      players[0].class.should == FakePlayer5
    end
  end
  
  context "when the user is selecting the number of words per phrase" do
    before(:each) do
      @renderer.stub(:output)
    end
    
    it "should return the number entered" do
      @renderer.should_receive(:output).with("Please the number of words per phrase:")
      @user_input.should_receive(:read_number).and_return(10)
      @user_input.select_num_of_words.should == 10
    end
    
    it "should not allow a number <= 0" do
      @user_input.should_receive(:read_number).once.ordered.and_return(0)
      @user_input.should_receive(:read_number).once.ordered.and_return(3)
      @renderer.should_receive(:output).with("You must enter a valid number of words (1 or more), please try again:")
      
      @user_input.select_num_of_words.should == 3
    end
  end
end

class FakePlayer3
end

class FakePlayer4
end

class FakePlayer5
end

class FakePlayer6
end