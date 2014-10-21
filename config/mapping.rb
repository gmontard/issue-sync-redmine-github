class Mapping

  attr_reader :priority, :assignee, :status

  def initiliaze
    @priority = priority
    @assignee = assignee
    @status = status
  end

  #####
  # key is alway the redmine ID, value is the Github corresponding data
  ####

  def priority
    {
      3 => "Low",
      4 => "Normal",
      5 => "High",
      6 => "Urgent"
    }
  end

  def assignee
    {
      1 => "gmontard",
      5 => "petrachi",
      20 => "jennyfer",
      19 => "Oliv75"
    }
  end

  def status
    {
      5 => "closed",
      14 => "open"
    }
  end

  def default_label
    "Bug"
  end
end
