# Demo player: Allows a human to enter the guess per turn. Please note that the class name ends with the word "Player" to enable loading.
class HumanDemoPlayer
  # Returns this players name.
  def name
    "Human Demo Player"
  end
  
  # Pepares for a new game (no action required for this player).
  def new_game(dictionary)
  end
  
  # For each turn, show a prompt to the user and return what was typed.
  def take_turn(pattern)    
    puts "Human player, please enter your guess:"
    gets.chomp!
  end
end