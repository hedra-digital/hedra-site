# == Schema Information
#
# Table name: features
#
#  id            :integer          not null, primary key
#  book_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  feature_image :string(255)
#  page_id       :integer
#

class Feature < ActiveRecord::Base
  # Relationships
  belongs_to                          :book, :inverse_of => :features
  belongs_to                          :page

  # Specify fields that can be accessible through mass assignment
  attr_accessible                     :book_id, :feature_image, :page_id, :external_site_url

  mount_uploader                      :feature_image, FeatureImageUploader

  validates                           :page_id, :presence => true, :if => Proc.new {|feature| feature.feature_image.present? && feature.external_site_url.nil?}
  validates                           :feature_image, :presence => true, :if => Proc.new {|feature| feature.page_id.present? }
  validates                           :external_site_url, :presence => true, :if => Proc.new {|feature| feature.book.nil? && feature.page.nil?}
end
