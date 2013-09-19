# -*- encoding : utf-8 -*-
class FeaturesPublisher < ActiveRecord::Base
  belongs_to                          :feature
  belongs_to                          :publisher
  attr_accessible                     :feature_id, :publisher_id
end
