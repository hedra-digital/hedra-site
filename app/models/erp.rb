class Erp
  def self.add_order(order)
    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => self.to_order(order) }.to_json, :content_type => :json)
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
        if address.location_id == nil and address.address_line1 == location["addressLine1"] and address.address_line2 == location["addressLine2"]
          address.location_id = location["id"]
          address.save
          break
        end
      end
    end
  end


  def self.sync_business_partner_location(orders)
    # which business_partner_location need to sync
    need_sync_orders = []
    orders.each do |order|
      business_partner = BusinessPartner.find_by_tax_id(order.cpf_cnpj)
      need_sync_orders << order if BusinessPartnerLocation.where(business_partner_id: business_partner.id, address_id: order.address.id).first == nil
    end

    # sync business_partner_location to erp
    business_partner_locations = []
    need_sync_orders.each {|order| business_partner_locations << self.to_business_partner_location(order)}
    results = self.api_wrapper(business_partner_locations)

    # insert in web app
    results.each do |business_partner_location|
      business_partner = BusinessPartner.find_by_erp_id(business_partner_location["businessPartner"])
      address = Address.find_by_location_id(business_partner_location["locationAddress"])
      BusinessPartnerLocation.create!(business_partner_id: business_partner.id, address_id: address.id, erp_id: business_partner_location["id"])
    end
  end


  def self.sync_order(orders)
    # which orders need to sync
    api_orders = []
    orders.each do |order|
      next if order.erp_id != nil
      api_orders << self.to_order(order)
    end

    # sync orders to erp
    results = self.api_wrapper(api_orders)

    # insert in web app
    results.each {|order| Order.find(order["orderReference"]).update_attributes(erp_id: order["id"]) }
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


  def self.add_address(order)
    response = RestClient.post(APP_CONFIG['openbravo_url'], { "data" => self.to_business_partner_location(order) }.to_json, :content_type => :json)
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

  def self.to_business_partner_location(order)
    business_partner = BusinessPartner.find_by_tax_id(order.cpf_cnpj)
    {
      _entityName: "BusinessPartnerLocation",
      name: "#{business_partner.id}_#{order.address.id}",
      businessPartner: business_partner.erp_id,
      locationAddress: order.address.location_id,
      organization: APP_CONFIG['openbravo_organization']
    }
  end

  def self.to_order(order)
    business_partner = BusinessPartner.find_by_tax_id(order.cpf_cnpj)
    business_partner_location = BusinessPartnerLocation.where(business_partner_id: business_partner.id, address_id: order.address.id).first
    {
      _entityName: "Order",
      documentType: APP_CONFIG['openbravo_order_document_type'],
      transactionDocument: APP_CONFIG['openbravo_order_document_type'],
      orderDate: order.created_at.as_json,
      accountingDate: order.created_at.as_json,
      orderReference: "#{order.id}",
      businessPartner: business_partner.erp_id,
      partnerAddress: business_partner_location.erp_id,
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
  end

end





