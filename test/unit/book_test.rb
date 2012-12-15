# == Schema Information
#
# Table name: books
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  pages           :integer
#  isbn            :string(255)
#  description     :text
#  width           :float
#  height          :float
#  weight          :float
#  released_at     :date
#  binding_type_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string(255)
#  cover           :string(255)
#  price_print     :float
#  price_ebook     :float
#  category_id     :integer
#

require 'test_helper'

class BookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
