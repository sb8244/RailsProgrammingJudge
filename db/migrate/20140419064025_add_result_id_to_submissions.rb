class AddResultIdToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :result_id, :integer
  end
end
