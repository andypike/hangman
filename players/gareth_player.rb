require 'logger'
require 'set'
require 'timeout'
class GarethPlayer
	# Returns this players name.
	
	attr_reader :taunt
	
	def name
		"Gareth Player"
	end

	def new_game dictionary
		@dictionary = dictionary
		@guessed = []
		@untried = ('a'..'z').to_a
	end

	def take_turn pattern
		words = pattern.split("/").map { |p| GuessableWord.new(p, @dictionary, @guessed) }

		correct_words = words.map { |w| w.unique }.compact
		case correct_words.length
		when words.length
			@taunt = "Done!"
			return words.map { |w| w.unique }.join("/")
		when 0
			@taunt = nil
		else
			@taunt = "I know #{correct_words.length} of the words" if rand > 0.4
		end

		best_letters = GarethPlayer.letter_signatures(words.map { |w| w.possible_words unless w.unique }.flatten.compact, @untried).sort_by { |k, v| -v.length }.map { |guess, signatures| guess }

		(best_letters & @untried).first.tap do |guess|
			@untried.delete(guess)
			@guessed << guess
		end
	end

	class GuessableWord
		def initialize pattern, dictionary, guessed = []
			@pattern = pattern
			@dictionary = dictionary
			@guessed = guessed
		end

		def unique
			possible_words.first if possible_words.length == 1
		end

		# Returns all remaining words from the dictionary which match the given (single word) pattern with the remaining letters
		def possible_words
			@dictionary.grep to_r
		end

		def to_r
			pattern_with_regexp_characters = @pattern.gsub(/[^a-z]/) do |match|
				case match
				when "_"
					@guessed.empty? ? "." : "[^#{@guessed.join}]"
				else
					Regexp.escape(match)
				end
			end
			Regexp.new("^#{pattern_with_regexp_characters}$")
		end

	end

	class << self
		def letter_selection words
			letter_signatures words
		end

		def letter_signatures words, untried_letters
			signatures = Hash.new { |h,k| h[k] = Set.new }
			words = words.shuffle
			Timeout.timeout(1) do
				words.each do |w|
					(w.split("").uniq & untried_letters).each do |l|
						signatures[l].add w.gsub(/[^#{l}]/, "_")
					end
				end
			end
		rescue Timeout::Error
		ensure
			return signatures
		end
	end

end