class AddIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :comments, :type
    add_index :reactions, :type
  end
end
