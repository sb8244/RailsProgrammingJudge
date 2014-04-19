class Problem < ActiveRecord::Base
  belongs_to :competition
  has_many :submissions
  has_many :test_cases
end
