# Represents a single game of hangman between the passed players
class Game
  PAUSE_BETWEEN_TURNS = 1
  
  # Instantiates a new game. Pass in the list of words as an array that can be used to generate a phrase to guess
  def initialize(words_list, renderer)
    @words_list = words_list
    @renderer = renderer
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
    
    @renderer.game_frame(states)
    
    #while true do
    #  @states.each do |state|
    #    sleep PAUSE_BETWEEN_TURNS
    #    guess = state.player.take_turn(state.current_pattern)
    #    state.turn_taken(guess.downcase, phrase)
    #    @renderer.game_frame(states)
    #  end
    
    #  players_found_phrase = @player_states.select { |s| s.found_phrase }
    #  if players_found_phrase.size == 1
    #    #Winner
    #    puts "We have a winner! #{players_found_phrase.first.player.name} found the phrase!"
    #    break
    #  elsif players_found_phrase.size > 1
    #    #Draw
    #    drawn_player_names = players_found_phrase.map { |s| s.player.name }
    #    puts "We have a draw between #{drawn_player_names.join(' and ')}"
    #    break
    #  else
    #    dead_players = @player_states.select { |s| s.incorrect_guesses.count >= @gallows.stages.count - 1 }
    #    if dead_players.count > 0
    #      dead_player_names = dead_players.map { |s| s.player.name }
    #      puts "Sorry, but you're dead: #{dead_player_names.join(' and ')}"
    #      break
    #    end
    #  end
    #end
    
  end
end