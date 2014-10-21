class GithubIssue

  def initialize(data)
    @raw_data = data
    @issue = data["issue"]
    @comment = data["comment"]
  end

  def id
    @id ||= @issue["number"]
  end

  def status
    @status ||= @issue["state"]
  end

  def assignee
    @assignee ||= @issue["assignee"]["login"] rescue nil
  end
end
