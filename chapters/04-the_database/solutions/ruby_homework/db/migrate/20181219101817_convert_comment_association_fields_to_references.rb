class ConvertCommentAssociationFieldsToReferences < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :post_id
    add_reference :comments, :post,
                  foreign_key: { on_delete: :cascade }
    remove_column :comments, :author_id
    add_reference :comments, :author,
                  foreign_key: { to_table: :users, on_delete: :cascade }
  end
end
