require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'factory_girl'
require 'factories'
Dir["./lib/*.rb"].each { |file| require file }