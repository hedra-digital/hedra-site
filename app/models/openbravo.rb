
class Openbravo
  BASE_URL = "#{APP_CONFIG['openbravo_url']}/BusinessPartner"

  def self.list_bp
    response =  RestClient.get BASE_URL
    json = JSON.parse(response)

    puts "#{json['response']['data'].count} Business Partners" 

		json["response"]["data"].each do |b|
		  puts b["name"]  
		end  

		nil
  end


  def self.get(id)
  	response =  RestClient.get "#{BASE_URL}/#{id}"
    json = JSON.parse(response)
    pp json
  end


  # (Client, Organization, Search Key) must be unique. 
  def self.add_list(limit_count)
  	users = User.where(synchronized: false).order("id").limit(limit_count)

    response = RestClient.post(BASE_URL, { "data" => self.users_to_data(users) }.to_json, :content_type => :json)

	  result = JSON.parse(response)
	  Rails.logger.info "OPENBRAVO::#{(pp result)}" 

	  if result["response"]["status"] == 0
	  	User.where(id: users.map(&:id)).update_all(synchronized: true)
	  end
  end



  private 

  def self.users_to_data(users)
  	result = []
  	users.each do |user|
  		result << {
			  _entityName: "BusinessPartner",
		    searchKey: user.email,
		    name: user.name,
		    organization: APP_CONFIG['openbravo_organization'],
		    businessPartnerCategory: APP_CONFIG['openbravo_business_partner_category']
	  	}
    end
    result
  end

end

