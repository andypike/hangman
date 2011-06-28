require 'logger'
class KyanTriceratopsPlayer
	# Returns this players name.
	def name
		"Kyan Triceratops Player"
	end

	# Prepares for a new game. Creates an array of letters that can be used to guess.
	def new_game(dictionary)
		@dictionary = dictionary.map { |w| w.chomp }
		@played_letters = []
		@letters = ('a'..'z').to_a
	end

	# For each turn, randomly select a letter from the remaining list, remove this letter from the array and return it.
	def take_turn(pattern)
		possible_words = expressions(pattern).map do |e|
			Regexp.new("^#{e}$")
		end.map do |e|
			possible_words(e, @letters)
		end

		guess = (best_letters(possible_words.flatten.uniq) & @letters).first

		@played_letters += [guess]
		@letters -= [guess]
		guess
	end

	def expressions(pattern)
		pattern.gsub(/_/, ".").split("/")
	end

	def possible_words(regexp, remaining_letters)
		matched_words = @dictionary.select{ |word| 
			word.match regexp
		}

		if remaining_letters.length > 0
			remaining_letters_reg = Regexp.new remaining_letters.join("|")
			matched_words.delete_if{ |word| !word.match remaining_letters_reg }
		end

		matched_words
	end

	def best_letters words
		letter, count = letter_distribution(words).sort_by { |l, count| -count }.map { |letter, count| letter }
	end

	def letter_distribution words
		words.inject({}) do |hsh, w|
			w.split("").uniq.each do |l|
				hsh[l] = (hsh[l] || 0) + 1
			end
			hsh
		end
	end

end