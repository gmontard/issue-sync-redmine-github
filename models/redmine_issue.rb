class RedmineIssue

  attr_accessor :issue

  def initialize(data)
    @raw_data = data["payload"]
    @issue = api["issue"]
  end

  def id
    @id ||= @raw_data["issue"]["id"]
  end

  def api
    @api ||= HTTParty.get("#{ENV['REDMINE_URL']}/issues/#{id}.json?key=#{ENV['REDMINE_API_KEY']}&include=attachments,journals")
  end

  def title
    @title ||= issue["subject"]
  end

  def description
    @description ||= issue["description"]
  end

  def status
    @status ||= issue["status"]["id"]
  end

  def author
    @author ||= issue["author"]["name"]
  end

  def attachments
    @attachments ||= get_attachments
  end

  def comments
    @comments ||= get_comments
  end

  def priority
    @priority ||= @@mapping.priority[api["issue"]["priority"]["id"].to_i] rescue nil
  end

  def assignee
    @assignee ||= @@mapping.assignee[api["issue"]["assigned_to"]["id"].to_i] rescue nil
  end

  def formated_description
    data = String.new

    data += "*This issue was generated automatically from Redmine*

**Author**: #{author}
**Issue URL**: http://#{ENV['REDMINE_URL']}/issues/#{id}

--
#### Description

#{description}
"

    attachments.each{|attachment|
       data += "
Attachment: #{attachment})"
    }

    if comments.present?

      data += "
\n
--
#### Comments"

      comments.each_with_index{|comment, i|
        data += "\n *#{comment[:author]} - #{comment[:date].to_date}*
#{comment[:comment]}\n\n--"
      }
    end

    data += "\n\n*Comment issue here: #{ENV['REDMINE_URL']}/issues/#{id}*"

    return(data)
  end

  def open?
    status == @@mapping.status.key("open")
  end

  private
  def get_attachments
    api["issue"]["attachments"].map{|attachment|
      attachment["content_url"]
    }
  end

  def get_comments
    api["issue"]["journals"].map{|journal|
      if journal["notes"].present?
        {
          comment: journal["notes"],
          author: journal["user"]["name"],
          date: journal["created_on"]
        }
      end
    }.compact!
  end
end
