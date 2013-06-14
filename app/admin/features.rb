ActiveAdmin.register Feature do

  controller do
    def scoped_collection
      Feature.includes(:book)
    end
  end

  show do |f|
    attributes_table do
      row :book
      row :feature_image do
        image_tag(f.feature_image_url(:thumb)) if f.feature_image.present?
      end
      row :page do
        f.page.tag.name if f.page_id.present?
      end
      row :external_site_url do
        f.external_site_url if f.external_site_url.present?
      end
    end
  end

  index do
    selectable_column
    column :id
    column "Book" do |f|
      f.book.present? ? f.book.title : ""
    end
    column "Tag" do |f|
      f.page.present? ? f.page.tag.name : ""
    end
    column "External site" do |f|
      f.external_site_url.present? ? f.external_site_url : ""
    end
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do

      f.inputs "Destaque com livro" do
        f.input :book, :collection => Book.order("title ASC").all
      end

      f.inputs "Destaque sem livro" do
        f.input :page, :collection => Page.all.map{|p| [p.tag.name, p.id] }
        f.input :feature_image, :as => :file, :hint => (( f.object.new_record? || f.object.feature_image.nil? ) ? f.template.content_tag(:span, "nenhuma imagem") : f.template.image_tag(f.object.feature_image.url(:thumb)))
      end
      f.inputs "Destaque sem livro para site externo" do
        f.input :external_site_url
        f.input :feature_image, :as => :file, :hint => (( f.object.new_record? || f.object.feature_image.nil? ) ? f.template.content_tag(:span, "nenhuma imagem") : f.template.image_tag(f.object.feature_image.url(:thumb)))
      end
    end
    f.buttons
  end

end
