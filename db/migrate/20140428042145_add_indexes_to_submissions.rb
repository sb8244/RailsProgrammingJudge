class AddIndexesToSubmissions < ActiveRecord::Migration
  def change
    change_column :submissions, :code, :string, null: false
    change_column :submissions, :language, :string, null: false
    change_column :submissions, :competition_id, :integer, null: false
  end
end
