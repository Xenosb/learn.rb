class AddSubRedditIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :sub_reddit_id, :integer
  end
end
