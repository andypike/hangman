require 'rspec/core/rake_task'
require 'rake/rdoctask'

RSpec::Core::RakeTask.new(:spec)

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb", "players/*.rb").exclude("players/andys_player.rb")
  rd.rdoc_dir = "docs"
  rd.title = "Surrey Rubyists Coding Competition: Hangman"
end

task :default => [:spec, :rdoc]