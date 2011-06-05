require "rbconfig"

# Renders output to the console
class ConsoleRenderer
  # Are we running on a Windows machine?
  WIN_OS = Config::CONFIG["host_os"] =~ /mswin|mingw/

  # Standard puts functionality for adhoc text output
  def output(text)
    puts text
  end
  
  # Clears the terminal (OS safe)
  def clear
    WIN_OS ? system("cls") : system("clear")
  end
  
  # Outputs a blank line to the console
  def blank_line
    output ""
  end
  
  # From a list of loaded player classes, display their names
  def render_players(players)
    output "Loaded Players"
    output "=============="
    
    players.each_with_index do |player, x|
      output "#{x + 1}: #{player.new.name}"
    end
  end
end