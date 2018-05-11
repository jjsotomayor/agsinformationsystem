# frozen_string_literal: true

module TimeHelper
  #TODO: Fix that the month is being displayed in English
  def date_time(timestamp)
    timestamp.strftime("%d/%b/%y - %H:%M")
  end

  def date(timestamp)
    timestamp.strftime("%d/%b/%y")
  end

  def time(timestamp)
    timestamp.strftime("%H:%M")
    # timestamp.strftime("%H:%M:%S")
  end

  def date_time_nil_safe(timestamp)
    timestamp.strftime("%d/%b/%y - %H:%M") if timestamp
  end

  def time_ago_in_text(t)
    diff_in_minutes = ((Time.now - t)/60).floor
    if diff_in_minutes < 90
      "(Hace #{diff_in_minutes} minutos)"
    else
      diff_in_hours = (diff_in_minutes.to_f/60).round(0)
      "(Hace #{diff_in_hours} horas)"
    end
  end

end
