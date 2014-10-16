# -*- encoding : utf-8 -*-
ActiveAdmin.register Page  do
  menu :parent => "CMS"

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :tag
      f.input :person, :as => :select, :collection => Person.order(:name)
      f.input :body
      f.input :tag_image, :as => :file, :hint => (( f.object.new_record? || f.object.tag_image.file.nil? ) ? f.template.content_tag(:span, "no photo yet") : f.template.image_tag(f.object.tag_image.url))
      f.input :hero_image, :as => :file, :hint => (( f.object.new_record? || f.object.hero_image.file.nil? ) ? f.template.content_tag(:span, "no photo yet") : f.template.image_tag(f.object.hero_image.url))
    end
    f.buttons
  end
end
