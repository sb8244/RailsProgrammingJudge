class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name
      t.datetime :start_time
      t.integer :duration

      t.timestamps
    end
  end
end
