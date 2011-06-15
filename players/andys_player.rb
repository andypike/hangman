class AndysPlayer
  def name
    "Andy's Super Duper Awesome Player"
  end

  def new_game(dictionary)
    @dictionary = dictionary
    @possible_words = nil
    @previous_guesses = []
    File.new("log.txt", "w")
  end

  def take_turn(pattern)  
    File.open("log.txt", 'a') do |log|
      log.write "************* Next Turn with pattern: #{pattern} *************\n"
      
      #Pick out each word from the phrase
      words = []
      word_patterns = pattern.split("/")
      word_patterns.each do |word_pattern|
        words << Word.new(word_pattern) unless word_pattern.index("_").nil?
      end
  
      #Process each word
      best_letters = {}
      words.each do |word|
        word.calculate_possible_words @dictionary
        word.calculate_unknown_letters_weighted_by_frequency
        best_letter = word.best_next_letter_guess @previous_guesses
        best_letters[best_letter].nil? ? best_letters[best_letter] = 1 : best_letters[best_letter] += 1
        
        log.write "Possible words for pattern #{word.pattern}: #{word.possible_words}\n"
        log.write "Letter frequencies for possible words: #{word.letters}\n"
        log.write "Best letter for word: #{best_letter}\n"
      end
    
      #Can we guess a word or phrase?
      single_words = words.select { |w| w.possible_words.size == 1  }
      single_words = single_words.map { |w| w.possible_words.first }
      if single_words.size == words.size
        phrase_guess = single_words.join("/")
        log.write "We know all the words so guess the phrase: #{phrase_guess}\n"
        @previous_guesses << phrase_guess
      elsif single_words.size > 0
        log.write "We know #{single_words.size} words so guess the first one: #{single_words.first}\n"
        @previous_guesses << single_words.first
      else
        #Can't guess a word or phrase yet to guess the best letter
        best_letter = ""
        best_letter_count = 0
        best_letters.each_pair do |letter, count|
          if count > best_letter_count
            best_letter = letter
            best_letter_count = count
          end
        end
    
        log.write "Guessing best letter candidate: #{best_letter}\n"
    
        @previous_guesses << best_letter
      end
    end 
    
    return @previous_guesses.last
  end


  class Word
    attr_reader :possible_words
    attr_reader :letters
    attr_reader :pattern
      
    def initialize(pattern)
      @pattern = pattern
      @regex = generate_regex
    end
  
    def calculate_possible_words(dictionary)
      @possible_words = dictionary.select { |w| @regex =~ w }
    end
  
    def calculate_unknown_letters_weighted_by_frequency
      missing_letter_indices = @pattern.all_indices("_")
    
      @letters = {}
      @possible_words.each do |possible_word|
        missing_letter_indices.each do |i|
          letter = possible_word[i]
          @letters[letter].nil? ? @letters[letter] = 1 : @letters[letter] += 1
        end
      end
    end
  
    def best_next_letter_guess(previous_guesses)
      best_letter = ""
      best_letter_count = 0
      @letters.each_pair do |letter, count|
        if count > best_letter_count && previous_guesses.index(letter).nil?
          best_letter = letter
          best_letter_count = count
        end
      end
      best_letter
    end
  
    private
  
    def generate_regex
      regex = "^"
      @pattern.each_char do |char|
        if char == "_"
          regex << "[a-z]"
        else
          regex << char
        end
      end
      regex << "$"
    
      Regexp.new(regex)
    end
  end
end