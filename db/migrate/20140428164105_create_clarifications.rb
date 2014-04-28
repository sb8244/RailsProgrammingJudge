class CreateClarifications < ActiveRecord::Migration
  def change
    create_table :clarifications do |t|
      t.string :question, null: false
      t.integer :problem_id, null: false
      t.integer :user_id, null: false
      t.string :answer
      t.boolean :global, default: true

      t.timestamps
    end
  end
end
