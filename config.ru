require 'dotenv'
Dotenv.load if defined?(Dotenv)

require './app'
run Sinatra::Application
