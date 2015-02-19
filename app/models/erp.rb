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
    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => self.to_bp(order) }.to_json, :content_type => :json)
	  result = JSON.parse(response)
	  Rails.logger.info "OPENBRAVO::#{(pp result)}" 
  end


  def self.sync_business_partner(orders)
    # which business partner need to sync
    need_sync = []
    orders.each {|order| need_sync << order if (!need_sync.map(& :cpf_cnpj).include?(order.cpf_cnpj) and BusinessPartner.find_by_tax_id(order.cpf_cnpj) == nil )}

    # sync business partner to erp
    business_partners = []
    need_sync.each {|order| business_partners << self.to_bp(order) }
    results = self.api_wrapper(business_partners)

    # insert in web app
    results.each {|business_partner| BusinessPartner.create!(tax_id: business_partner["taxID"], erp_id: business_partner["id"]) }
  end

  # one location can be added twice in erp 
  def self.sync_location(orders)
    #which location need to sync
    addresses = []
    orders.each {|order| addresses << order.address if order.address.location_id == nil}

    # sync location to erp
    locations = []
    addresses.each {|address| locations << self.to_location(address)}
    results = self.api_wrapper(locations)

    # insert in web app
    results.each do |location|
      addresses.each do |address|
        if address.location_id == nil and address.address_line1 == location.addressLine1 and address.address_line2 == location.addressLine2
          address.location_id = location.id
          address.save
          break
        end
      end
    end
  end


  # add a object or a list of objects
  def self.api_wrapper(objs)
    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => objs }.to_json, :content_type => :json)
    result = JSON.parse(response)
    Rails.logger.info "OPENBRAVO::#{(pp result)}" 

    if result["response"]["status"] == 0
      return result["response"]["data"]
    else
      return nil
      # todo error handle
    end
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
    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => self.to_location(order) }.to_json, :content_type => :json)
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


  private


  def self.to_bp(order)
    {
      _entityName: "BusinessPartner",
      searchKey: order.cpf_cnpj.delete("./-"),
      name: order.user.name,
      taxID: order.cpf_cnpj,
      organization: APP_CONFIG['openbravo_organization'],
      businessPartnerCategory: APP_CONFIG['openbravo_business_partner_category']
    }
  end

  def self.to_location(address)
    {
      _entityName: "Location",
      addressLine1: address.address_line1,
      addressLine2: address.address_line2,
      country: "139",
      organization: APP_CONFIG['openbravo_organization']
    }
  end



end





