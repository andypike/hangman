# The hangman game runner. This loads the word list and players. Manages the creation of a new game.
class Hangman
  # Initializes the game runner passing in the dictionary and player loader to use
  def initialize(renderer, dictionary_loader, player_loader)
    @dictionary_loader = dictionary_loader
    @player_loader = player_loader
    @renderer = renderer
  end
  
  # Start the application, load words and players
  def start
    @renderer.clear
    @renderer.output "Welcome to Hangman"
    @renderer.output "=================="
    @renderer.blank_line
    
    @words = @dictionary_loader.load("dictionary.txt")
    @players = @player_loader.load("players")
    
    @renderer.render_players @players
    @renderer.blank_line
    
    # Display loaded players
    # Select players
    # Enter number of words
    # Start game
  end
end