# Responsible for analysing the state of the game through the game loop and deciding if the game has finished
class GameAnalyser
  # Creates a new analyser, taking the current player states and a renderer
  def initialize(states, renderer)
    @states = states
    @renderer = renderer
  end
  
  # Returns true if the game is over, otherwise returns false. Will render the reason if the game is over
  def game_over?
    players_found_phrase = @states.select { |s| s.found_phrase }
    if players_found_phrase.size == 1
      @renderer.output "We have a winner! #{players_found_phrase.first.player.name} found the phrase!"
      return true    
    elsif players_found_phrase.size > 1
      drawn_player_names = players_found_phrase.map { |s| s.player.name }
      @renderer.output "We have a draw between #{drawn_player_names.join(' and ')}"
      return true
    else
      dead_players = @states.select { |s| s.incorrect_guesses.count >= Gallows.stages.count - 1 }
      if dead_players.count > 0
        dead_player_names = dead_players.map { |s| s.player.name }
        @renderer.output "#{dead_player_names.join(' and ')} is dead."
        if dead_players.count == @states.count
          @renderer.output "It's a draw, all players are dead."
        else
          surviving_players = @states.select { |s| dead_players.index(s).nil? }
          surviving_player_names = surviving_players.map { |s| s.player.name }
          @renderer.output "We have a winner! #{surviving_player_names.join(' and ')} survived longer!"
        end
        return true
      end
    end
    return false
  end
end