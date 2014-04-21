class RemoveFieldsFromProblems < ActiveRecord::Migration
  def up
    remove_column :problems, :submission_id
    remove_column :problems, :test_case_id
  end

  def down
    add_column :problems, :submission_id, :integer
    add_column :problems, :test_case_id, :integer
  end
end
