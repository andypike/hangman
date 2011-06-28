# Demo player: Allows a human to enter the guess per turn. Please note that the class name ends with the word "Player" to enable loading.
class TeamVelociraptorPlayer
  # Returns this players name.
	attr_accessor :frequency_hash, :letters, :vowels

  def name
    "Team Velociraptor Player"
  end
  
  # Prepares for a new game (no action required for this player).
  def new_game(dictionary)
		@dictionary = dictionary
		@frequency_hash = frequency_hash
		@vowels = vowels
		@letters = letters
  end
  
  # For each turn, show a prompt to the user and return what was typed.
  def take_turn(pattern)
		unless @vowels.empty?
			vowel = @vowels.delete_at(0)
			@letters.delete(vowel)
			vowel
		else
			@letters.delete_at(0)
		end
  end

	def frequency_hash
		hash = {}	
		@dictionary.each do |word|
			word.split(//).each do |letter|
				hash[letter] = (hash[letter].nil? ? 1 : (hash[letter] += 1))
			end
		end
		hash = Hash[hash.sort_by { |k,v| [-1 * v, -1 * k.to_i] }]
	end

	
	def letters
		frequency_hash.keys
	end
	
	def vowels
		["a","e","i","o","u"]
	end
end