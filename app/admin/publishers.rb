# -*- encoding : utf-8 -*-
ActiveAdmin.register Publisher do
  menu :parent => "CMS"

  index do
    selectable_column
    column :name
    column :url
    column :logo
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :name
      f.input :url
      f.input :logo, :as => :file, :hint => (( f.object.new_record? || f.object.logo.nil? ) ? f.template.content_tag(:span, "no photo yet") : f.template.image_tag(f.object.logo.url(:thumb)))
    end
    f.buttons
  end
end
