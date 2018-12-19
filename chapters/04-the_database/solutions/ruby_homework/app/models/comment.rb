# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  author_id  :integer
#

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :author, class_name: 'User'

  validates :content, presence: true, length: { minimum: 2 }
end
