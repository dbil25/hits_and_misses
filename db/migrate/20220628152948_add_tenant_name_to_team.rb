class AddTenantNameToTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :tenant_name, :string
  end
end
