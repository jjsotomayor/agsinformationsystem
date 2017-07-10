# frozen_string_literal: true

module TimeHelper
  #TODO: Fix that the month is being displayed in English
  def date_time(timestamp)
    timestamp.strftime("%d/%b/%y - %H:%M:%S")
  end

  def date(timestamp)
    timestamp.strftime("%d/%b/%y")
  end

  def time(timestamp)
    timestamp.strftime("%H:%M:%S")
  end

end
