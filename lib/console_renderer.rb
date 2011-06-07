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
  
  # Outputs the main welcome message
  def welcome
    clear
    output "Welcome to Hangman"
    output "=================="
    blank_line
  end
  
  # From a list of loaded player classes, display their names
  def players_list(players)
    output "Loaded Players"
    output "=============="
    
    players.each_with_index do |player, x|
      output "#{x + 1}: #{player.new.name}"
    end
    output "* No players loaded :o(" if players.empty?
    
    blank_line
  end
  
  # Display a list of errors while loading players
  def errors(errors)
    output "Errors Loading Players"
    output "======================"
    
    errors.each do |error|
      output "* #{error}"
    end
    output "* No errors to report :o)" if errors.empty?
    
    blank_line
  end
end