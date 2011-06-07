# From the loaded word list this class can generate new phrases to guess and also turn 
# these into patterns for players to see the format of the phrase without giving away the phrase
class PhraseGenerator
  # Generates a phrase containing specified number of words in the form "this/is/a/phrase" (words separated by forward-slashes)
  def self.generate(num_of_words, words_list)
    words = words_list.sample num_of_words
    phrase = words.join "/"
  end
  
  # Takes a phrase in the form "this/is/a/phrase" and replaces the letters with underscores to generate a pattern in the form "____/__/_/______"
  def self.patternize(phrase)
    phrase.gsub(/[a-z]/, '_')
  end
end