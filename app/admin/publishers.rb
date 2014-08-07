ActiveAdmin.register Publisher do
  menu :parent => "CMS"

  index do
    selectable_column
    column :name
    column :url
    column :contact_email
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :name
      f.input :url
      f.input :contact
      f.input :contact_email
      f.input :logo, :as => :file, :hint => (( f.object.new_record? || f.object.logo.nil? ) ? f.template.content_tag(:span, "no photo yet") : f.template.image_tag(f.object.logo.url(:thumb)))
      f.input :about
      f.input :about_label
      f.input :about_title
      f.input :distributors
      f.input :link_url
      f.input :link_name
      f.input :tracking_id, :label => "Tracking ID"
    end
    f.buttons
  end
end
