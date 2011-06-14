# Represents a single game of hangman between the passed players
class Game
  # Instantiates a new game. Pass in the list of words as an array that can be used to generate a phrase to guess
  def initialize(words_list, renderer)
    @words_list = words_list
    @renderer = renderer
  end
  
  # Pauses execution for 1 second to allow the guesses to be visible and create a better game to watch
  def pause
    sleep 1
  end
  
  # Starts the game and continues to allow the players to take turns until one is victorious (or it's a draw)
  def start(num_of_words, players)
    phrase = PhraseGenerator.generate(num_of_words, @words_list)
    pattern = PhraseGenerator.patternize(phrase)

    states = []
    players.each do |player|
      player.new_game Array.new(@words_list)
      states << PlayerState.new(player, String.new(pattern))
    end

    analyser = GameAnalyser.new(states, @renderer)    
    @renderer.game_frame(states)
    
    begin
      states.each do |state|
        pause
        
        guess = state.player.take_turn(String.new(state.current_pattern))
        state.turn_taken(guess.downcase, phrase) if guess && guess.respond_to?(:downcase)
        
        @renderer.game_frame(states)
      end
    end until analyser.game_over?
    
    @renderer.output "The phrase to find was: #{phrase}"
    @renderer.blank_line
  end
end