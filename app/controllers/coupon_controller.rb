class CouponController < ApplicationController
  def set_cookie
    promotion = Promotion.find_by_slug(params[:id])
    if promotion
      cookies["coupon_#{promotion.id}".to_sym] = { value: promotion.slug, expires: promotion.ended_at, domain: :all }

      if !promotion.link.blank?
      	redirect_to promotion.link
      	return
      end
    end
  	redirect_to "/"
  end
end
