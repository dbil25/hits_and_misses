class AddUniqueIndexesToTeam < ActiveRecord::Migration[7.0]
  def change
    add_index :teams, :tenant_name, unique: true
    add_index :teams, :name, unique: true
  end
end
