namespace :deliver_reports do
  
  desc "Send Comission Reports by Mail to Partners"
  task :partnership => :environment do
   	PromotionReport.details_partners_promotion.each do |promotion_report|
   	  PartnershipMailer.weekly(promotion_report).deliver
   	end
  end

end
