# The hangman game runner. This loads the word list and players. Manages the creation of a new game.
class Hangman
  # Initializes the game runner passing in the dictionary and player loader to use
  def initialize(dictionary_loader, player_loader)
    @dictionary_loader = dictionary_loader
    @player_loader = player_loader
  end
  
  # Start the application, load words and players
  def start
    puts "Welcome to Hangman"
    
    @words = @dictionary_loader.load("dictionary.txt")
    @players = @player_loader.load("players")
  end
end