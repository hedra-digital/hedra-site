class BusinessPartner < ActiveRecord::Base
  attr_accessible :tax_id, :erp_id
  validates_presence_of :tax_id, :erp_id
  validates_uniqueness_of :tax_id, :erp_id
end
