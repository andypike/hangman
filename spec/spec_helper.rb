require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

Dir["./lib/*.rb"].each { |file| require file }