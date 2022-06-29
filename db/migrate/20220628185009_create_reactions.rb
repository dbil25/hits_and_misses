class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.string :type
      t.references :author, null: false
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
