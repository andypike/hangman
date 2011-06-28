# A class for handling all user input
class ConsoleUserInput
  # Initializes the class passing a renderer for user prompts
  def initialize(renderer)
    @renderer = renderer
  end
  
  # Reads a number from the console
  def read_number
    input = gets.chomp
    exit if input == "exit"
    input.to_i
  end
  
  # Allows the user to select the specified number of players from the list of loaded players
  def select_players(num_of_players, players)
    selected = []
    num_of_players.times do |i|
      @renderer.output "Please select player #{i + 1}:"
      
      player_number = read_number_with_validation("You must enter a valid player number, please try again:") { |num| num > 0 && num <= players.size }
      
      selected << players[player_number - 1].new
    end
    selected
  end
  
  # Allows the user to select the number of words per phrase
  def select_num_of_words
    @renderer.output "Please the number of words per phrase:"
    read_number_with_validation("You must enter a valid number of words (1 or more), please try again:") { |num| num > 0 }
  end
  
  private 
  
  # Helper to enable reading numbers from the console and showing an error message if the number 
  # fails validation. Continues to loop, asking the user to try again until a valid input is entered
  def read_number_with_validation(message, &validation)    
    begin
      num = read_number
      @renderer.output message unless validation.call(num)
    end while validation.call(num) == false
    num
  end
end