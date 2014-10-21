class Issue < ActiveRecord::Base

  validates_uniqueness_of :redmine_id, :github_id, :allow_nil => true

  def update_on_redmine(github)
    options = redmine_options(github)
    HTTParty.put("#{ENV['REDMINE_URL']}/issues/#{self.redmine_id}.json?key=#{ENV['REDMINE_API_KEY']}", options)
  end

  def create_on_github(redmine)
    options = github_options(redmine)
    res = HTTParty.post("https://api.github.com/repos/#{ENV['GITHUB_REPO']}/issues", options)
    self.github_id = res["number"]
    self.save
  end

  def update_on_github(redmine)
    options = github_options(redmine)
    HTTParty.patch("https://api.github.com/repos/#{ENV['GITHUB_REPO']}/issues/#{github_id}", options)
  end

  private
  def github_options(redmine)
    github_params.merge!({
      body: {
        title: redmine.title,
        body: redmine.formated_description,
        state:  @@mapping.status[redmine.status],
        labels: [@@mapping.default_label, redmine.priority].compact,
        assignee: redmine.assignee
      }.to_json
    })
  end

  def github_params
    {
      headers: {
        "Accept" => "application/vnd.github.v3+json",
        "User-Agent" => ENV['GITHUB_OWNER']
      },
      basic_auth: {
        username: ENV['GITHUB_API_KEY'],
        password: "x-oauth-basic"
      }
    }
  end

  def redmine_options(github)
    {
      body: {
        issue: {
          status_id: @@mapping.status.key(github.status),
          assigned_to_id: @@mapping.assignee.key(github.assignee),
        }
      }
    }
  end

end
