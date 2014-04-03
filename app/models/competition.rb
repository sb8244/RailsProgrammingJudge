class Competition < ActiveRecord::Base

  # Derive the end time based on the start_time
  def end_time
    start_time + duration.minutes
  end
end
