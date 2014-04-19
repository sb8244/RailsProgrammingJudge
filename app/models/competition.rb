class Competition < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :problems

  # Derive the end time based on the start_time
  def end_time
    start_time + duration.minutes
  end

  def running?
    !before? && !after?
  end

  def before?
    Time.now < start_time
  end

  def after?
    Time.now > end_time
  end
end
