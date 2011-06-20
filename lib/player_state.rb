# Represents the current state of a player during the game
class PlayerState
  attr_reader :player
  attr_accessor :current_pattern
  attr_reader :correct_guesses
  attr_reader :incorrect_guesses
  attr_reader :found_phrase
  
  # Creates a player state object. Pass in the player and the pattern of the current game
  def initialize(player, pattern)
    @player = player
    @current_pattern = pattern
    @correct_guesses = []
    @incorrect_guesses = []
    @found_phrase = false
  end
  
  # Called by the game once a player has taken a turn. This then updates the player state including guesses and current pattern (to pass to the player next time round)
  def turn_taken(guess, phrase)
    if guess.nil?
      @incorrect_guesses << "[nil]"
    elsif !guess.respond_to?(:downcase)
      @incorrect_guesses << "[invalid]"
    elsif guess.empty?
      @incorrect_guesses << "[empty]"
    else
      guess = guess.downcase.gsub(/ /, "/")
      
      if guess.size > 1 && guess.size < phrase.size
        # This is a word guess, do not allow part of a word guesses
        words = phrase.split("/")
        matching_words = words.select {|w| w == guess}
        if matching_words.size == 0
          @incorrect_guesses << guess
          return
        end
      end
      
      matches = phrase.all_indices(guess)
    
      if matches.empty?
        @incorrect_guesses << guess
      else
        @correct_guesses << guess
      
        matches.each do |i|
          x = 0
          guess.each_char do |c|
            @current_pattern[i + x] = c
            x = x + 1
          end
        end
      
        @found_phrase = @current_pattern.index("_") == nil
      end
    end
  end
end