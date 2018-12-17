# == Schema Information
#
# Table name: posts
#
#  id            :integer          not null, primary key
#  author_id     :integer
#  content       :text
#  published     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sub_reddit_id :integer
#  title         :string           default(""), not null
#

class Post < ApplicationRecord
end
