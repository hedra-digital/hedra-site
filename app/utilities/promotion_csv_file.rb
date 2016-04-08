require 'csv'
class PromotionCsvFile
  class << self
    def upload(params)
      file = params[:file].read
      CSV.parse(file) do |row|
        data = fetch_group_attributes row
        return if data.blank?
        partner = Partner.new(data[:partner])
        partner.save!

        promotion = Promotion.new(data[:promotion])
        promotion.partner_id  = partner.id
        
        # @fixME this couldn't be hardcode, change domain, breaks all
        promotion.link = "http://hedra.com.br/categoria/#{promotion.category.slug}" if promotion.category.present?
        promotion.save!

        if params[:notify].to_i == 1
          promotion.notify_partner
        end
      end
    end

    def fetch_group_attributes(row = [])
      return if row.blank?
      data = {
        promotion: {
          category_id:        row[0],
          publisher_id:       row[1],
          discount:           row[2],
          started_at:         row[3],
          ended_at:           row[4],
          slug:               row[5].present? ? row[5] : SecureRandom.uuid,
          link:               row[6],
          for_traffic_origin: row[7].to_i == 0 ? false : true,
          name:               row[8]
        },

        partner: {
          name:               row[9],
          email:              row[10],
          comission:          row[11]
        }
      }
    end
  end
end