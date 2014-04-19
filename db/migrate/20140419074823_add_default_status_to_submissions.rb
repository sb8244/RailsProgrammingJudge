class AddDefaultStatusToSubmissions < ActiveRecord::Migration
  def up
    Submission.all.each do |submission|
      submission.status = "not_started" if submission.status.nil?
      submission.save!
    end
    change_column :submissions, :status, :string, default: "not_started", null: false
  end

  def down
    change_column :submissions, :status, :string, default: nil, null: true
  end
end
