class Submission < ActiveRecord::Base
  belongs_to :problem
  belongs_to :user
  belongs_to :competition
  has_many :test_case_results
end
