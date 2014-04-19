class AddTestCasesToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :test_case_id, :integer
  end
end
