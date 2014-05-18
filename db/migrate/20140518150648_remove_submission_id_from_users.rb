class RemoveSubmissionIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :submission_id
  end
  def down
    add_column :users, :submission_id, :integer
  end
end
