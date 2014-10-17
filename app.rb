require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/issue'

get '/' do
end

post '/submit' do
	@issue = Issue.new(params[:model])
	if @issue.save
		redirect '/issues'
	else
		"Sorry, there was an error!"
	end
end

get '/issues' do
	@issues = Issue.all
end

after do
  # Close the connection after the request is done so that we don't
  # deplete the ActiveRecord connection pool.
  ActiveRecord::Base.connection.close
end
