class HardOfThinkingPlayer
    attr_accessor :guesses, :words_by_length

    def name
      'Steve'
    end

    def new_game(dictionary)
      # A new game has started, do any clean up from a previous game and initialise for this one. 
      # The dictionary passed is the full set of words that the phrase is selected from and is passed in as a string array: ["apple", "bear", "cat"]
      @dictionary = dictionary
      @guesses = []
    end

    def take_turn(pattern)
      # It's your turn. Return a guess (string) which can either be a letter, word or whole phrase.
      # The current state of your pattern is passed in the format "s_rr__/r____s_s" 
      # The pattern is made up from: underscore = missing letter, forward slash = space, letter = correctly placed
      next_char_by_frequency(pattern)
    end

    def next_char_by_frequency(pattern)
      # match = exact_match(pattern)
      # return match if match
      @chars_by_frequency = chars_by_frequency_for(pattern)
      @chars_by_frequency.sort{ |a, b| b[1] <=> a[1] }.each do |pair|
        if !guesses.include?(pair[0])
          guesses << pair[0]
          return pair[0]
        end
      end
    end

    def chars_by_frequency_for(pattern)
      chars_by_frequency = {}
      @dictionary.select{ |w| matches_pattern_list(w, pattern) }.each do |word|
        word.chars do |ch|
          chars_by_frequency[ch] = 0 if !chars_by_frequency.has_key?(ch)
          chars_by_frequency[ch] = chars_by_frequency[ch] + 1
        end
      end
      chars_by_frequency
    end

    def matches_pattern_list(w, pattern_list)
      pattern_list.split('/').each do |pattern|
        return true if matches_pattern(w, pattern)
      end
      false
    end

    def matches_pattern(word, pattern)
      return false if word.size != pattern.size
      (0..(word.size - 1)).each do |index|
        return false if pattern[index] != '_' && pattern[index] != word[index]
      end
      true
    end

    def exact_match(pattern_list)
      pattern_list.split('/').each do |pattern|
        match = exact_matches_pattern(pattern)
        return match if match
      end
      nil
    end

    def exact_matches_pattern(pattern)
      matches = []
      @dictionary.select{ |w| matches_pattern_list(w, pattern) }.each do |word|
        matches << w if pattern =~ /\_/ && matches_pattern(w, pattern)
      end
      return matches[0] if matches.size == 1
      false
    end
  end


