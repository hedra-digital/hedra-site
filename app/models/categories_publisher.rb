# -*- encoding : utf-8 -*-
class CategoriesPublisher < ActiveRecord::Base
  belongs_to                          :category
  belongs_to                          :publisher
  attr_accessible                     :category_id, :publisher_id
end
