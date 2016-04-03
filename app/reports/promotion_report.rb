class PromotionReport
	
	def self.details_partners_promotion
	  result = []
	  Promotion.includes(:partner).find_each do |promotion|
	  	lw_order_ids = promotion.orders.select(:id).completed_at_last_week
	  	cm_order_ids = promotion.orders.select(:id).completed_at_current_month

	  	items_lw = order_items lw_order_ids 
	  	items_cm = order_items cm_order_ids 
	  	
	  	partner = promotion.partner
	  	result << {
	  	  items:   items_lw, 
	  	  orders:  lw_order_ids.size,
	  	  start_date: 1.week.ago.beginning_of_week(:sunday),
	  	  end_date: 1.week.ago.end_of_week(:sunday),
	  	  partner_name: partner.name,
	  	  partner_email: partner.email,
	  	  partner_comission: partner.comission,
	  	  revenue_week: items_lw.inject(0){ |revenue, item|
	  	  	item[:price] * item[:quantity] * partner.comission
	  	  },
	  	  revenue_month: items_cm.inject(0){ |revenue, item|
	  	  	item[:price] * item[:quantity] * partner.comission
	  	  }
	  	}
	  end
	  result
	end

	def self.order_items(order_ids)
	  OrderItem.joins(:book).select(
	    'sum(order_items.price) price,
	  	 sum(order_items.quantity) quantity,
 	     books.title title,
 	     books.id as book_id'
 	  )
 	  .group(:book_id)
 	  .where(order_id: order_ids)
 	  .map{|item| 
 	  	item.sym_attributes.merge({ people: people_names(item.book_id) })
 	  }
	end

	def self.people_names(book_ids)
	  Participation.where(book_id: book_ids).map{|participation| participation.person.name }
	end
end