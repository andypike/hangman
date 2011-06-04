Dir["./lib/*.rb"].each { |file| require file }

hangman = Hangman.new
hangman.start