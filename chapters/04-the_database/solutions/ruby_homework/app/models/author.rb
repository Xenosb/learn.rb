# == Schema Information
#
# Table name: authors
#
#  id            :integer          not null, primary key
#  email         :string
#  alias         :string
#  date_of_birth :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Author < ApplicationRecord
end
