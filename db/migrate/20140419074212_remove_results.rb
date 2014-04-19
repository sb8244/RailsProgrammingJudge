class RemoveResults < ActiveRecord::Migration
  def up
    drop_table :results if ActiveRecord::Base.connection.table_exists? 'results'
  end
  def down
  end
end
