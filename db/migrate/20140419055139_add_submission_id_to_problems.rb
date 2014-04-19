class AddSubmissionIdToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :submission_id, :integer
  end
end
