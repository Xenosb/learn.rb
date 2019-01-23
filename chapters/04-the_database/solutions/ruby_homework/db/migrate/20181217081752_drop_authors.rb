class DropAuthors < ActiveRecord::Migration[5.2]
  def up
    drop_table :authors
  end

  def down
    create_table :authors do |t|
      t.string :email
      t.string :alias
      t.datetime :date_of_birth

      t.timestamps
    end
  end
end
