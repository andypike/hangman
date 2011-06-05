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
  
  context "when rendering the list of loaded players" do
    before(:each) do
      @renderer.stub(:output)
    end
    
    it "should output each player name" do 
      @renderer.should_receive(:output).with("1: Andy's Awesome Player")
      @renderer.should_receive(:output).with("2: Another cool Player")
      
      @renderer.render_players([FakePlayer1, FakePlayer2])
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