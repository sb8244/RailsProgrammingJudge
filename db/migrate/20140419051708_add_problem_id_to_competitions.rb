class AddProblemIdToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :problem_id, :integer
  end
end
