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

  form do |f|
    f.semantic_errors
    f.inputs "Promotion" do
      f.input :book
      f.input :tag
      f.input :category
      f.input :publisher
      f.input :discount
      f.input :price
      f.input :started_at
      f.input :ended_at
      f.input :slug
      f.input :link
      f.input :name, label: "Campaign name"
      f.input :for_traffic_origin
    end

    f.inputs "Partners" do
      if f.object.new_record?
        f.semantic_fields_for :partner_attributes do |j|
          j.inputs do
            j.input :name,      label: "Partner Name"
            j.input :email,     label: "Partner Email"
            j.input :comission, label: "Partner Comission"
          end
        end
      else
        f.semantic_fields_for :partner do |j|
          j.inputs do
            j.input :name,      label: "Partner Name"
            j.input :email,     label: "Partner Email"
            j.input :comission, label: "Partner Comission"
          end
        end
      end
    end

    f.actions
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
