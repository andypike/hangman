class ThreeDayMonkPlayer
  # Returns this players name.
  def name
    "threedaymonk (normal)"
  end

  # Prepares for a new game (no action required for this player).
  def new_game(dictionary)
    @dictionary = dictionary
    @played = []
    @rejected = []
  end

  # For each turn, show a prompt to the user and return what was typed.
  def take_turn(pattern)
    guess = exact_phrase(pattern)
    return guess if guess

    most_likely(pattern).tap{ |play|
      @played << play
    }
  end

private

  def threshold
    2
  end

  def exact_phrase(pattern)
    rejected = @played - pattern.scan(/[a-z]/)
    reject_pattern = rejected.any? && Regexp.new("[" + rejected.join("") + "]")
    if reject_pattern
      possible_words = @dictionary.select{ |w| w !~ reject_pattern }
    else
      possible_words = @dictionary
    end

    all = pattern.split("/").map{ |wpat|
      regexp = wpat_regexp(wpat)
      possible_words.select{ |w| w=~ regexp }
    }

    total = all.inject(0){ |a,e| a + e.length }
    if (total - pattern.split("/").length) < threshold
      all.map{ |w| w[rand(w.length)] }.join("/")
    else
      nil
    end
  end

  def most_likely(pattern)
    dict  = dictionary_for_turn(pattern)
    freqs = find_frequencies(dict)

    candidates = freqs.sort_by{ |l,f| -f }.
                       map{ |l,f| l }

    best(candidates - @played)
  end

  def best(a)
    a.first
  end

  def find_frequencies(words)
    Hash.new{ |h, k| h[k] = 0 }.tap{ |f|
      words.each do |word|
        word.scan(/[a-z]/).each do |letter|
          f[letter] += 1
        end
      end
    }
  end

  def wpat_regexp(wpat)
    Regexp.new("^" + wpat.gsub("_", ".") + "$")
  end

  def dictionary_for_turn(pattern)
    rejected = @played - pattern.scan(/[a-z]/)
    reject_pattern = rejected.any? && Regexp.new("[" + rejected.join("") + "]")
    [].tap{ |result|
      pattern.split("/").each do |known|
        regexp = wpat_regexp(known)
        @dictionary.each do |word|
          if word.match(regexp) && !(reject_pattern && word.match(reject_pattern))
            result << word
          end
        end
      end
    }
  end
end

class ThreeDayMonkFuzzyPlayer < ThreeDayMonkPlayer
  def name
    "threedaymonk (fuzzy)"
  end

private
  def best(a)
    a[rand([2, a.length].min)]
  end

  def threshold
    3
  end
end
