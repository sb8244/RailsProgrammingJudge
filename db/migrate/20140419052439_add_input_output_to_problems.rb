class AddInputOutputToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :input_example, :string
    add_column :problems, :output_example, :string
  end
end
