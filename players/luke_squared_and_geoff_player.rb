class LukeSquaredAndGeoffPlayer
  # Returns this players name.
  def name
    "Luke & Geoff's Player"
  end

  # Prepares for a new game. Creates an array of letters that can be used to guess.
  def new_game(dictionary)
    @dictionary = {}
    @used = {}
    @letters_in_words_of_size_x = {}
    @popularity_of_letters = {}
    dictionary.each do |word|
      (@dictionary[word.size] ||= []) << word
      letters = word.scan(/./)
#      (@letters_in_words_of_size_x ||= []) << letters.uniq
      hash = (@popularity_of_letters[word.size] ||= {})
      letters.each do |letter|
        hash[letter] ||= 0
	hash[letter] += 1
      end
    end
  end

  class WordPattern
    attr_reader :pattern
    def initialize(pattern)
      @pattern = pattern
      @options = []
    end
    def regex
      @re ||= Regexp.new("^#{@pattern.gsub(/_/, '.')}$", Regexp::IGNORECASE)
    end
    def size
      @pattern.size
    end
    attr_accessor :options
    def done?
      !(/_/.match(@pattern))
    end
  end

  def take_turn(pattern)
    bits = pattern.scan(/[^\/]+/).map { |bit| WordPattern.new(bit) }
    #letters_in_pattern = pattern.scan(/./).sort.uniq - ['_', '/']
    #regexes = bits.map { |b| [b.size, Regexp.new("^#{b.gsub(/_/, '.')}$", Regexp::IGNORECASE)] }

    bits.each do |wp|
      next if wp.done?
      wp.options = @dictionary[wp.size].select { |word| wp.regex.match(word) }
    end

    # Do we know whole phrase?  If so return it
    if bits.all? { |bit| bit.done? || bit.options.size == 1 }
    	return bits.map { |bit| "#{bit.options[0] || bit.pattern}" }.join("/")
    end

    # Do we know any new words?
    missing_words = bits.reject { |wp| wp.done? }.size
    bits.each do |bit|
    	next if bit.done?
        if bit.options.size == 1
	  return bit.options[0]
	end
    end if missing_words < 10

    # What's the most likely character ?
    bits.each do |bit|
      bit.pattern.scan(/./).each do |char|
        next if char == '_'
      end
    end

    possible_chars = {}
    bits.each do |wp|
      next if wp.done?
      wp.options.each do |word|
        word.scan(/./).each do |let|
        next if @used[let]
        possible_chars[let] ||= 0
	possible_chars[let] += 1
      end
      end
    end

    options = possible_chars.sort_by { |k,v| v }
    guess = options.last[0]
    @used[guess] = true
    return guess
  end
end
