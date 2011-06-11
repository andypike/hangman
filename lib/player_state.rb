class PlayerState
  attr_reader :player
  attr_reader :current_pattern
  attr_reader :correct_guesses
  attr_reader :incorrect_guesses
  attr_reader :found_phrase
  
  def initialize(player, pattern)
    @player = player
    @current_pattern = pattern
    @correct_guesses = []
    @incorrect_guesses = []
    @found_phrase = false
  end
  
  def turn_taken(guess, phrase)
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