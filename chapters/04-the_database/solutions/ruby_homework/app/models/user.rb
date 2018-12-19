# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_many :comments, foreign_key: 'author_id'

  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true, presence: true
end
