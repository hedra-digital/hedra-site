ActiveAdmin.register Book do

  index do
    column :title
    column :isbn
    column :pages
    column :description
    column :updated_at
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :title
      f.input :isbn
      f.input :pages
      f.input :description, :input_html => { :id => 'nicedit-1' }
      f.input :cover, :as => :file, :hint => (( f.object.new_record? || f.object.cover.nil? ) ? f.template.content_tag(:span, "no photo yet") : f.template.image_tag(f.object.cover.url(:thumb)))
      f.has_many :participations do |association|
          if !association.object.nil?
            association.input :_destroy, :as => :boolean, :label => "Apagar?"
          end
          association.input :role
          association.input :person
      end
      f.input :released_at
      f.input :binding_type
      f.inputs "Medidas" do
        f.input :width
        f.input :height
        f.input :weight
      end
      f.inputs "Idiomas" do
        f.input :languages
      end
    end
    f.buttons
  end


end
