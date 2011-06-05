Dir["./lib/*.rb"].each { |file| require file }

hangman = Hangman.new(DictionaryLoader.new, PlayerLoader.new)
hangman.start