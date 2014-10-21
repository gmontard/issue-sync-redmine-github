begin
  require 'dotenv'
  Dotenv.load
rescue LoadError => e
  puts "DotEnv not loaded, it's OK if you are in Production"
end

require "sinatra/activerecord/rake"
require "./app"
