class MarkEmblingPlayer
  def name
    '@markembling "I don\'t know what I\'m doing..."'
  end

  def new_game(dictionary)
    @letters_used = []
    @possible_words = dictionary
    
    @letters = []
  end

  def take_turn(pattern)
    filter_words(pattern)
    populate_letters_with_frequency_in_words
    
    find_likely_letter
  end
  
  private
  
  def filter_words(pattern)
    word_patterns = pattern.split '/'
    
    word_lengths = word_patterns.collect{|x| x.length }
    
    word_patterns.each do |wp|
      @possible_words.delete_if do |poss|
        has = word_lengths.select{|len| len == poss.length }.first.nil?
        !has
      end
    end
  end
  
  def populate_letters_with_frequency_in_words
    @possible_words.each do |word|
      word.each_char do |letter|
        found = @letters.select{|x| x[0] == letter }.first
                
        if found.nil?
          @letters << [letter, 1]
        else
          idx = @letters.index(found)          
          @letters[idx] = [letter, found[1] + 1]
        end
      end
    end
  end
  
  def find_likely_letter  
    sorted = @letters.sort{|a,b| a[1] <=> b[1] }
    chosen = sorted.last.first
    
    unless @letters_used.select{|x| x == chosen}.first.nil?
      # remove from list
      @letters.delete_if {|x| x[0] == chosen }
      
      # pick another
      chosen = find_likely_letter
    end
    
    # record this
    @letters_used << chosen
    
    chosen
  end
end

