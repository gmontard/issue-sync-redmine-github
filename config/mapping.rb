class Mapping

  attr_reader :priority, :assignee, :status

  def initialize
  end

  def priority
    {
      1 => "Low",
      2 => "Normal",
      3 => "High",
      4 => "Urgent"
    }
  end

  def assignee
    {
      1 => "gmontard"
    }
  end

  def status
    {
      1 => "closed",
      2 => "open"
    }
  end

  def default_label
    "Bug"
  end
end
