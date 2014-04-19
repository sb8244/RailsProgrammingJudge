class RemoveResultIdFromSubmissions < ActiveRecord::Migration
  def up
    remove_column :submissions, :result_id
  end
  
  def down
    add_column :submissions, :result_id, :integer
  end
end
