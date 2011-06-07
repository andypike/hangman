# The hangman game runner. This loads the word list and players. Manages the creation of a new game.
class Hangman
  # Initializes the game runner passing in the dictionary and player loader to use
  def initialize(renderer, dictionary_loader, player_loader, user_input)
    @dictionary_loader = dictionary_loader
    @player_loader = player_loader
    @renderer = renderer
    @user_input = user_input
  end
  
  # Start the application, load words and players then allows the user to select the players and number of words per phrase.
  # Once valid input has been received, it creates a new game and enters the game loop
  def start
    words = @dictionary_loader.load("dictionary.txt")
    players = @player_loader.load("players")
    
    @renderer.welcome
    @renderer.errors @player_loader.errors
    @renderer.players_list players
    
    selected_players = @user_input.select_players(2, players)
    num_of_words = @user_input.select_num_of_words

    # Start the game
    new_game = Game.new(words)
    new_game.start(num_of_words, selected_players)
  end
end