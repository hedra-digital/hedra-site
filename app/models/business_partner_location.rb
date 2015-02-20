class BusinessPartnerLocation < ActiveRecord::Base
  attr_accessible :address_id, :business_partner_id, :erp_id
  validates_presence_of :address_id, :business_partner_id, :erp_id
  validates_uniqueness_of :erp_id
end
