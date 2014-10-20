class Issue < ActiveRecord::Base

  validates_uniqueness_of :redmine_id, :github_id

  def close_on_redmine
    options = {
      body: {
        issue: {
          status_id: '5'
        }
      }
    }

    HTTParty.put("http://dev.vodeclic.com/issues/#{self.redmine_id}.json?key=73f69296fb4828263a60226517dea6b001b6aa36", options)
  end

  def create_on_github(redmine)
    options = github_params.merge!({
      body: {
        title: redmine.title,
        body: redmine.formated_description,
        labels: "Bug"
      }.to_json
    })

    HTTParty.post("https://api.github.com/repos/Vodeclic/Vodeclic/issues", options)
  end

  def update_on_github(redmine)
    options = github_params.merge!({
      body: {
        title: redmine.title,
        body: redmine.formated_description,
        state: (redmine.closed? ? "closed" : "open")
      }.to_json
    })

    HTTParty.patch("https://api.github.com/repos/Vodeclic/Vodeclic/issues/#{github_id}", options)
  end

  private
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

end
