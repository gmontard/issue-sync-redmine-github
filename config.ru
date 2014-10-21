require 'dotenv'
Dotenv.load

require './app'
run Sinatra::Application
