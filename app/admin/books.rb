# -*- encoding : utf-8 -*-
ActiveAdmin.register Book do
  menu :parent => "CMS"

  index do
    selectable_column
    column :title
    column :isbn
    column :pages
    column :description
    column :updated_at
    column :category
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :title
      f.input :isbn
      f.input :pages
      f.input :publisher, :collection => Publisher.order("name")
      f.input :category, :collection => Category.order("name")
      f.input :description
      f.input :cover, :as => :file, :hint => (( f.object.new_record? || f.object.cover.nil? ) ? f.template.content_tag(:span, "no photo yet") : f.template.image_tag(f.object.cover.url(:thumb)))
      f.has_many :participations do |association|
        association.input :_destroy, :as => :boolean, :label => "Apagar?" unless (association.object.new_record? || association.object.nil?)
        association.input :role
        association.input :person, :collection => Person.order("name ASC").all
      end
      f.input :ebook, :as => :file, :hint => (( f.object.new_record? || f.object.ebook.file.nil? ) ? f.template.content_tag(:span, "no ebook yet") : f.template.content_tag(:span, f.object.ebook.url))
      f.input :price_print
      f.input :price_ebook
      f.input :packet_discount
      f.input :released_at, :as => :date_select, :include_blank => true, :start_year => 1999, :order => [:year, :month, :day]
      f.input :binding_type
      f.input :position
      f.inputs "Medidas" do
        f.input :width
        f.input :length
        f.input :weight
      end
      f.inputs "Idiomas" do
        f.input :languages
      end
      f.inputs "Tags" do
        f.input :tags, :as => :check_boxes
      end
    end
    f.buttons
  end
end
