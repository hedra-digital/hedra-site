class Erp
  def self.add_order(order, bp_id, address_id)
    o = {
      _entityName: "Order",
      documentType: APP_CONFIG['openbravo_order_document_type'],
      transactionDocument: APP_CONFIG['openbravo_order_document_type'],
      orderDate: order.created_at.as_json,
      accountingDate: order.created_at.as_json,
      businessPartner: bp_id,
      partnerAddress: address_id,
	    organization: APP_CONFIG['openbravo_organization'],
      currency: "297", # the id of BRL in db
      invoiceTerms: "I", # I (Immediate): Immediate Invoice
      paymentTerms: APP_CONFIG['openbravo_order_payment_terms'],
      paymentMethod: APP_CONFIG['openbravo_order_payment_method'],
      warehouse: APP_CONFIG['openbravo_order_warehouse'],
      priceList: APP_CONFIG['openbravo_order_price_list'],
      summedLineAmount: order.total.to_f,
      grandTotalAmount: order.total.to_f
    }

    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => o }.to_json, :content_type => :json)
    result = JSON.parse(response)
    Rails.logger.info "OPENBRAVO::#{(pp result)}" 
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


  def self.add_address(order, bp_id, l_id)
  	location = "#{order.address.address}, #{order.address.number}, #{order.address.city}, #{order.address.state}, #{order.address.zip_code}"

  	address = {
      _entityName: "BusinessPartnerLocation",
      name: location,
      businessPartner: bp_id,
      locationAddress: l_id,
		  organization: APP_CONFIG['openbravo_organization']
    }

    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => address }.to_json, :content_type => :json)
    result = JSON.parse(response)
	  Rails.logger.info "OPENBRAVO::#{(pp result)}" 
  end

   def self.add_location(order)
  	location = {
      _entityName: "Location",
		  addressLine1: "#{order.address.address}, #{order.address.number}, #{order.address.city}, #{order.address.state}, #{order.address.zip_code}",
		  country: "139",
		  organization: APP_CONFIG['openbravo_organization']
    }

    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => location }.to_json, :content_type => :json)
    result = JSON.parse(response)
	  Rails.logger.info "OPENBRAVO::#{(pp result)}" 
  end


  def self.list(entity_type, name_like = nil)
  	if name_like.nil?
      response =  RestClient.get "#{APP_CONFIG['openbravo_url']}/#{entity_type}"
    else
      response =  RestClient.get "#{APP_CONFIG['openbravo_url']}/#{entity_type}?_where=name%20like'%25#{name_like}%25'"
    end
    pp JSON.parse(response)
    nil
  end



end



