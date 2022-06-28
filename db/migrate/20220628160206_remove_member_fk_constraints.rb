class RemoveMemberFkConstraints < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key "members", "teams"
    remove_foreign_key "members", "users"
  end
end
