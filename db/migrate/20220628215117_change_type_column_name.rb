class ChangeTypeColumnName < ActiveRecord::Migration[7.0]
  def change
    remove_index :reactions, :type
    remove_column :reactions, :type, :string
    add_column :reactions, :content, :string
    add_index :reactions, :content
  end
end
