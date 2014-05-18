class CreateTestCaseResults < ActiveRecord::Migration
  def change
    create_table :test_case_results do |t|
      t.text :output, null: false
      t.text :status, null: false
      t.integer :submission_id, null: false
      t.integer :test_case_id, null: false

      t.timestamps
    end
  end
end
