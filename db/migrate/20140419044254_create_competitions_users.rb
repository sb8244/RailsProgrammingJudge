class CreateCompetitionsUsers < ActiveRecord::Migration
  def change
    create_table :competitions_users do |t|
      t.belongs_to :user
      t.belongs_to :competition
    end
  end
end
