# Loads the word list from a text file. The file should contain a single word per line.
class DictionaryLoader
  #Loads the specified text file and creates an array containing each word. The word list is sorted and made lowercase
  def load(file_path)
    file = File.open file_path, "r"
    words = file.readlines.map(&:chomp)
    file.close
    
    return words.map { |word| word.downcase }.sort
  end
end