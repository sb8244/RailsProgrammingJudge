class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :problem_id
      t.integer :user_id
      t.string :status
      t.string :code
      t.string :language

      t.timestamps
    end
  end
end
