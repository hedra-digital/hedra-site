class Erp
  def self.add_order(order)
  end

  def self.add_bp(order)
  	business_partner = {
			  _entityName: "BusinessPartner",
		    searchKey: order.cpf_cnpj.delete("./-"),
		    name: order.user.name,
		    taxID: order.cpf_cnpj,
		    organization: APP_CONFIG['openbravo_organization'],
		    businessPartnerCategory: APP_CONFIG['openbravo_business_partner_category']
	  	}

    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => business_partner }.to_json, :content_type => :json)
	  result = JSON.parse(response)
	  Rails.logger.info "OPENBRAVO::#{(pp result)}" 
  end


  def self.add_address(order, bp_id)
  	location = "#{order.address.address}, #{order.address.number}, #{order.address.city}, #{order.address.state}, #{order.address.zip_code}"

  	address = {
      _entityName: "BusinessPartnerLocation",
      name: location,
      businessPartner: bp_id
    }

    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => address }.to_json, :content_type => :json)
    result = JSON.parse(response)
	  Rails.logger.info "OPENBRAVO::#{(pp result)}" 
  end

end

