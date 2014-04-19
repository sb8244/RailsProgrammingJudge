class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.integer :competition_id
      t.string :name
      t.string :html

      t.timestamps
    end
  end
end
