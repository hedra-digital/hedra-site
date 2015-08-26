class CouponController < ApplicationController
  def set_cookie
    promotion = Promotion.find_by_slug(params[:id])
    redirect_target = :root

    if promotion
      create_cookie_for promotion
      redirect_target = promotion.link unless promotion.link.blank?
    end

    redirect_to redirect_target
  end

  private
    def create_cookie_for(promotion)
      if promotion.for_traffic_origin
        value = [promotion.id, promotion.name.downcase.gsub(/\s+/, ' ').split(" ")].flatten.join("_")
        cookies["current_campaign"] = {
          value: value,
          expires: promotion.ended_at,
          domain: :all
        }
      else
        cookies["coupon_#{promotion.id}".to_sym] = {
          value: promotion.slug,
          expires: promotion.ended_at,
          domain: :all
        }
      end
    end
end
