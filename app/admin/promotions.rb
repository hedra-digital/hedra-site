ActiveAdmin.register Promotion do
  menu :parent => "eCommerce"

  index do
    column :id
    column :price
    column :discount
    column :name
    column :for_traffic_origin
    column "coupon" do |p|
      link_to(p.slug, "http://#{p.publisher.url}/coupon/#{p.slug}") unless p.slug.blank?
    end
    default_actions
  end

  controller do
    def new
      super do |format|
        @promotion.started_at = Time.now
        @promotion.ended_at = Time.now + 1.month
        @promotion.slug = SecureRandom.uuid
      end
    end

    rescue_from ActiveRecord::DeleteRestrictionError do |exception|
      redirect_to(:back, :alert => exception.message)
    end
  end

end
