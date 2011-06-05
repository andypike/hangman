# Responsible for loading the players and performing some check to ensure they are valid
class PlayerLoader
  # After loading, gives a list of errors (if any) for the players that it tried to load
  attr_reader :errors
  
  # For a given folder, load the player files. Check that each player has implemented the correct methods and loads correctly.
  # Returns an array of player classes that the caller can instantiate when required.
  def load(folder_path)
    players = []
    @errors = []
    
    Dir["#{folder_path}/*.rb"].each do |player_file| 
      require_player_file player_file
    end
    
    Module.constants.select do |constant_name|
      constant = eval constant_name.to_s
      if not constant.nil? and constant.is_a? Class and constant_name.to_s.end_with? "Player"
        if check_method(constant, constant_name, 'name') && check_method(constant, constant_name, 'new_game') && check_method(constant, constant_name, 'take_turn')  
           players << constant
        end
      end
    end
    
    return players
  end
  
  private
  
  # Requires the specified file and logs an error if there is a syntax error raised
  def require_player_file(player_file)
    begin
      require "./#{player_file}"
    rescue SyntaxError
      @errors << "Failed to load player '#{player_file}' due to a syntax error: #{$!}"
    end
  end
  
  # For the given player class, check that it implements the specified method. If not log the error and return false. Otherwise return true.
  def check_method(constant, constant_name, method_name)
    instance = constant.new
    unless instance.respond_to?(method_name)
      @errors << "Failed to load player '#{constant_name.to_s}' because it doesn't contain the method: #{method_name}"
      return false
    end
    
    return true
  end
end