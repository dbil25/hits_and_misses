class AddDurationAndStartedAtToMeetings < ActiveRecord::Migration[7.0]
  def change
    add_column :meetings, :duration_seconds, :integer
    add_column :meetings, :started_at, :datetime
  end
end
