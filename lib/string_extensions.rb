class String
  def all_indices(char)
    indices = []
    
    pos = -1
    until (pos = self.index(char, pos + 1)).nil?
      indices << pos
    end
    
    return indices
  end
end