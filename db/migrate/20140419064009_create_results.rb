class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :submission_id
      t.string :status

      t.timestamps
    end
  end
end
