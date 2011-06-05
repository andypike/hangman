# Demo player: A pretty stupid player, just randomly returns a letter each turn. Doesn't guess the same letter twice in the same game.
class StupidDemoPlayer
  # Returns this players name.
  def name
    "Stupid Demo Player"
  end
  
  # Pepares for a new game. Creates an array of letters that can be used to guess.
  def new_game(dictionary)
    @dictionary = dictionary
    @letters = ('a'..'z').to_a
  end
  
  # For each turn, randomly select a letter from the remaining list, remove this letter from the array and return it.
  def take_turn(pattern)    
    i = rand(@letters.count)
    @letters.delete_at(i)
  end
end