class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.integer :problem_id, null: false
      t.string :input, null: false
      t.string :output, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
