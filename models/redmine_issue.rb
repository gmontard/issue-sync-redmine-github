class RedmineIssue
  def initialize(data)
    @raw_data = data["payload"]
    @issue = @raw_data["issue"]
  end

  def id
    @id ||= @issue["id"]
  end

  def title
    @title ||= @issue["subject"]
  end

  def description
    @description ||= @issue["description"]
  end

  def status
    @status ||= @issue["status"]["id"]
  end

  def author
    @author ||= @issue["author"]["firstname"] + " " + @issue["author"]["firstname"]
  end

  ## Call redmine API to get more info on the hook triggered
  def api
    @api ||= HTTParty.get("http://dev.vodeclic.com/issues/#{id}.json?key=73f69296fb4828263a60226517dea6b001b6aa36&include=attachments,journals")
  end

  def attachments
    @attachments ||= get_attachments
  end

  def comments
    @comments || get_comments
  end

  #########

  def formated_description
    data = String.new

    data += "*This issue was generated automatically from Redmine*

**Author**: #{author}
**Issue URL**: http://dev.vodeclic.com/issues/#{id}

--
#### Description

#{description}
"

    attachments.each{|attachment|
       data += "
Attachment: #{attachment})"
    }

    comments.each_with_index{|comment, i|
       data += "
\n
--
#### Comment #{i+1}
**Author**: #{comment[:author]}
**Date**: #{comment[:date].to_date}

#{comment[:comment]}\n\n"
    }

    data += "\n\n--\n*Comment issue here: http://dev.vodeclic.com/issues/#{id}*"

    return(data)
  end

  def validated?
    status == 14 || closed?
  end

  def closed?
    status == 5
  end

  def opened?
    status != 5
  end

  private
  def url_for_attachment(attachment)
    "http://dev.vodeclic.com/attachments/#{attachment["prop_key"]}.json?key=73f69296fb4828263a60226517dea6b001b6aa36"
  end

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
