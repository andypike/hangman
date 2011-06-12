# Extending the string class with extra methods
class String
  # Returns an array containing the indices of where the passed string is found in the target string
  def all_indices(char)
    indices = []
    
    pos = -1
    until (pos = self.index(char, pos + 1)).nil?
      indices << pos
    end
    
    return indices
  end
end