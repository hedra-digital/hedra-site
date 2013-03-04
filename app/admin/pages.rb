ActiveAdmin.register Page  do
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :tag
      f.input :body, :as => :ckeditor
      f.input :tag_image, :as => :file, :hint => (( f.object.new_record? || f.object.tag_image.nil? ) ? f.template.content_tag(:span, "no photo yet") : f.template.image_tag(f.object.tag_image.url))
      f.input :hero_image, :as => :file, :hint => (( f.object.new_record? || f.object.hero_image.nil? ) ? f.template.content_tag(:span, "no photo yet") : f.template.image_tag(f.object.hero_image.url))
    end
    f.buttons
  end
end
