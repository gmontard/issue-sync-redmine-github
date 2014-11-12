### Purpose

This Project let you **Sync Redmine issues with Github issues** with some caveats (on purpose).

### Why ?

[We](http://www.vodeclic.com) use Redmine as a bug reporter for our internal and non technical teams and our developers manage them on Github for a better development workflow.

### How it work?

- First an issue has to be created on Redmine
- If the issue has a specific status (ID) then it's synced to Github
- If you modify the issue on Redmine those fields will reflect on Github:
  - Title
  - Description
  - Assignee
  - Status (open or closed on Github)
  - Priority (as a label)
  - Comments / Attached file (will update issue description)

- If you modify the issue on Github those fields will reflect on Redmine:
  - Assignee
  - Status (as open or closed)

If you'd like to change those behaviors it should be pretty straightford to do so, do not hesitate to fork the project.

### Requirements

#### On Redmine

- You need a Redmine install >= 2.4, [REST Api](http://www.redmine.org/projects/redmine/wiki/Rest_api) enabled and the [Redmine Webhook](https://github.com/suer/redmine_webhook) plugin.
- Configure the Redmine Webhook URL to point to this App install (*http://your-app-install/redmine_hebook*)

#### On Github

- Create a [Github personnal access token](https://github.com/settings/tokens/new) with rights on *Repo* checkbox
- Configure a Webhook URL for your Github repo to point to this App install (http://your-app-install/github_hebook)
- Go to your repository setting (https://github.com/username/repo/settings/hooks), click "Add webhook", in the *Payload URL* field use this App URL (**http://your-app-install/github_hebook**), check event *Issues* and activate it.

#### Configure the Application

In order to sync data between Redmine and Github we need a way to map some fields, this is the role of the *config/mapping.rb* file, you should edit it:
~~~ruby
# config/mapping.rb
# On those hash, keys refer to Redmine ID and value to Github corresponding one

## Github doesn't handle priority so it will be converted to labels
def priority
  {
    1 => "Low",
    2 => "Normal",
    3 => "High",
    4 => "Urgent"
  }
end

## Map Redmine user to Github user
def assignee
  {
    1 => "gmontard"
  }
end

## Map Redmine status to Github status (which can only be closed or open)
def status
  {
    1 => "closed",
    2 => "open"
  }
end

## Default label for all issues
def default_label
  "Bug"
end
~~~

- You need to setup those environments variables in order for the App to work:
~~~console
DATABASE_URL  # Database URL (ex: postgres://localhost/issue-sync-redmine-github)
DATABASE_NAME  # Database name
DATABASE_USERNAME  # Database username (ex: postgres)
DATABASE_PASSWORD  # Database password
DATABASE_HOST  # Database host (ex: localhost)
REDMINE_URL  # Your Redmine Public base URL
REDMINE_API_KEY  # Your Redmine API Key is available on your account page (*/my/account*)
GITHUB_API_KEY  # Your Github access token
GITHUB_OWNER  # Your Github Username
GITHUB_REPO  # Your Github project Repo (for ex: *gmontard/issue-sync-redmine-github*)
NEWRELIC_API_KEY # NewRelic API KEY
~~~

- In development you should creare a *.env* file and set those variables (see section *Running in Development*)

- In production, if you use Heroku as mentioned below we'll use *heroku config* command (see section *Deploy on Heroku*)


### Running in Development

- Build the Box:
~~~console
vagrant up --provision
vagrant ssh
~~~

- Edit the *config/mapping* file and create a *.env* file, below some default env variables:
~~~console
DATABASE_URL=postgres://localhost/issue-sync-redmine-github
DATABASE_NAME=issue-sync-redmine-github
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=
DATABASE_HOST=localhost
~~~

- Finish to configure the application:
~~~console
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
rackup
~~~

- Also a console is available:
~~~console
racksh
~~~


### Deploy on Heroku

- Login through Heroku and create your heroku App:
~~~console
heroku login
heroku create
~~~

- Add Postgresql Add-on
~~~console
heroku addons:add heroku-postgresql
~~~

- Retrieve Postgresql Credentials
~~~console
heroku config
#ex: => postgres://gvupfefeizddbfk:zURnLz87hjhfegsLjpl-DZ@ec2-5455-24-51-1.compute-1.amazonaws.com:5432/jfkej87jhfp9
~~~

- Set the environments variables on Heroku:
~~~console
heroku config:set DATABASE_URL=postgres://gvupfefeizddbfk:zURnLz87hjhfegsLjpl-DZ@ec2-5455-24-51-1.compute-1.amazonaws.com:5432/jfkej87jhfp9
heroku config:set DATABASE_NAME=jfkej87jhfp9
heroku config:set DATABASE_USERNAME=gvupfefeizddbfk
heroku config:set DATABASE_PASSWORD=zURnLz87hjhfegsLjpl-DZ-bD
heroku config:set DATABASE_HOST=ec2-5455-24-51-1.compute-1.amazonaws.com
heroku config:set REDMINE_URL=
heroku config:set REDMINE_API_KEY=
heroku config:set GITHUB_OWNER=
heroku config:set GITHUB_REPO=
heroku config:set GITHUB_API_KEY=
heroku config:set NEWRELIC_API_KEY=
~~~

- Deploy in production and run migrations
~~~console
git push heroku master && heroku run rake db:migrate
~~~


### Useful commands on Heroku

- Watching logs
~~~console
heroku logs --tail
~~~

- Restarting the App
~~~console
heroku restart
~~~

- Running rake command
~~~console
heroku run rake COMMAND
~~~

- Launching ruby console
~~~console
heroku run racksh
~~~


*Do not forget to configure Webhook URL on Redmine and Github according to *Requirements* section above.*


### Technology

- Ruby 2.1
- Sinatra
- Postgresql


### License

Copyright © 2014 Guillaume Montard and Vodeclic SAS released under the MIT license
