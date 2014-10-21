class Issue < ActiveRecord::Base

  validates_uniqueness_of :redmine_id, :github_id, :allow_nil => true

  def update_on_redmine(github)
    options = redmine_options(github)
    HTTParty.put("http://dev.vodeclic.com/issues/#{self.redmine_id}.json?key=73f69296fb4828263a60226517dea6b001b6aa36", options)
  end

  def create_on_github(redmine)
    options = github_options(redmine)
    res = HTTParty.post("https://api.github.com/repos/Vodeclic/Vodeclic/issues", options)
    self.github_id = res["number"]
    self.save
  end

  def update_on_github(redmine)
    options = github_options(redmine)
    HTTParty.patch("https://api.github.com/repos/Vodeclic/Vodeclic/issues/#{github_id}", options)
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
        "User-Agent" => "gmontard"
      },
      basic_auth: {
        username: "7e0dbe637070b63bed187a2f48f95b9ddcc9c913",
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
