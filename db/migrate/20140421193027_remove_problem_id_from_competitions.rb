class RemoveProblemIdFromCompetitions < ActiveRecord::Migration
  def up
    remove_column :competitions, :problem_id
  end
  def down
    add_column :competitions, :problem_id, :integer
  end
end
