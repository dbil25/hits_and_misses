class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :type
      t.references :author, null: false
      t.references :meeting, null: false, foreign_key: true

      t.timestamps
    end
  end
end
