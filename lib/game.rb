# Represents a single game of hangman between the passed players
class Game
  # Instantiates a new game. Pass in the list of words as an array that can be used to generate a phrase to guess
  def initialize(words_list)
    @words_list = words_list
  end
  
  # Starts the game and continues to allow the players to take turns until one is victorious (or it's a draw)
  def start(num_of_words, players)
    phrase = PhraseGenerator.generate(num_of_words, @words_list)
    
  end
end