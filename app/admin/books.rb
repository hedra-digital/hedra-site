ActiveAdmin.register Book do

  index do
    selectable_column
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
      f.input :description, :as => :ckeditor
      f.input :cover, :as => :file, :hint => (( f.object.new_record? || f.object.cover.nil? ) ? f.template.content_tag(:span, "no photo yet") : f.template.image_tag(f.object.cover.url(:thumb)))
      f.has_many :participations do |association|
        association.input :_destroy, :as => :boolean, :label => "Apagar?" unless (association.object.new_record? || association.object.nil?)
        association.input :role
        association.input :person
      end
      f.input :price_print
      # f.input :price_ebook
      f.input :released_at, :as => :date_select, :include_blank => true, :start_year => 1999, :order => [:year, :month, :day]
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
