class AddSubmissionIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :submission_id, :integer
  end
end
