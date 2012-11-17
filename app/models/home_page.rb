class HomePage < ActiveRecord::Base
  # Relationships
  belongs_to                          :book, :foreign_key => :home_page_id, :inverse_of => :feature
  belongs_to                          :book, :foreign_key => :home_page_id, :inverse_of => :new_release
  belongs_to                          :book, :foreign_key => :home_page_id, :inverse_of => :recommendation

  # Allow other models to be nested within this one
  accepts_nested_attributes_for       :features, :new_releases, :recommendations
end
