ActiveAdmin.register Feature do

  controller do
    def scoped_collection
      Feature.includes(:book)
    end
  end

  index do
    selectable_column
    column :id
    column :book
    column :updated_at
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :book
      f.input :feature_image, :as => :file, :hint => (( f.object.new_record? || f.object.feature_image.nil? ) ? f.template.content_tag(:span, "nenhuma imagem") : f.template.image_tag(f.object.feature_image.url))
    end
    f.buttons
  end

end
