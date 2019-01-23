class CreateSubReddits < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_reddits do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.boolean :private, null: false, default: false
      t.integer :owner_id, null: false

      t.timestamps
    end
  end
end
