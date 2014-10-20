require 'sinatra'
require 'httparty'
require "redcarpet"
require 'pry'
require 'sinatra/activerecord'
require './config/environments'
require './models/redmine_issue'
require './models/github_issue'
require './models/issue'

get '/' do
	content_type :json
	Issue.all.to_json
end

post '/redmine_hook' do
	data = JSON.parse request.body.read
	redmine = RedmineIssue.new(data)

	## Is issue with status "validated" on Redmine?
	if redmine.validated?
		issue = Issue.find_or_create_by_redmine_id(redmine.id)

		### is issue already present on Github?
		if issue.github_id.present?
			res = issue.update_on_github(redmine)
		else
			res = issue.create_on_github(redmine)
			issue.github_id = res.body["id"]
			issue.save
		end
	end

	"OK"
end

post '/github_hook' do
	data = JSON.parse(request.body.read)
	github = GithubIssue.new(data)

	issue = Issue.where(github_id: github.id)

	## Issue already created on Redmine and has status closed on Github
	if issue.present? && github.status = "closed"
		issue.close_on_redmine
	end

	"OK"
end

after do
  # Close the connection after the request is done so that we don't
  # deplete the ActiveRecord connection pool.
  ActiveRecord::Base.connection.close
end
