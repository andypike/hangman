Dir["./lib/*.rb"].each { |file| require file }

console_renderer = ConsoleRenderer.new
user_input = ConsoleUserInput.new(console_renderer)
hangman = Hangman.new(console_renderer, DictionaryLoader.new, PlayerLoader.new, user_input)
hangman.start