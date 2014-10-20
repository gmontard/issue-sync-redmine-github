class GithubIssue

  def initialize(data)
    @raw_data = data
    @issue = data["issue"]
    @comment = data["comment"]
  end

  def id
    @id ||= @issue["number"]
  end

  def title
    @title ||= @issue["title"]
  end

  def description
    @description ||= @issue["body"]
  end

  def labels
    @labels ||= @issue["labels"].map{|label| label["name"]}
  end

  def status
    @status ||= @issue["state"]
  end

  def last_comment
    @last_comment ||= @comment["body"] if @comment.present?
  end
end
