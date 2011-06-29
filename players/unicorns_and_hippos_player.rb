class UnicornsAndHipposPlayer
  def name
    "UnicornsAndHippos"
  end

  def new_game(dictionary)
    @dictionary = Dictionary.new(dictionary)
    @guesses = []
    # A new game has started, do any clean up from a previous game and initialise for this one. 
    # The dictionary passed is the full set of words that the phrase is selected from and is passed in as a string array: ["apple", "bear", "cat"]
  end

  def take_turn(pattern)
    to_match = pattern.split('/').select{|word| word =~ /_/}
    matches = to_match.map{|word| @dictionary.matches(word)}
    matches.each{|match| return match.first if match.size == 1}

    @dictionary = Dictionary.new(matches.flatten)

    guess = @dictionary.next
    while to_match.join.include? guess or @guesses.include? guess do
      guess = @dictionary.next
    end
    @guesses << guess
    guess
  end

  # If your player needs supporting classes, you can nest them inside your player class.
  # This is to keep things simple for the player loader and also to avoid clashes between players.
  class Dictionary
    def initialize(dictionary)
      @words = dictionary
      concatenated_string = dictionary.join
      @frequencies = {}
      ('a'..'z').each {|c| @frequencies[c] = concatenated_string.count(c)}
    end

    def count(char)
      @frequencies[char]
    end

    def next
      freqs = @frequencies.sort_by{|char, count| count}.reverse
      @frequencies[freqs.first[0]] = 0
      freqs.first[0]
    end

    def matches(pattern)
      @words.select{|word| word =~ /^#{pattern.gsub('_','.')}$/}
    end
  end
end
