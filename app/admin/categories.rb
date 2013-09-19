# -*- encoding : utf-8 -*-
ActiveAdmin.register Category do
  menu :parent => "CMS"

  form do |f|
    f.inputs do
      f.input :publishers, :as => :check_boxes, :wrapper_html => { :class => "multicolumn1" }, :collection => Publisher.all
      f.input :name
      f.input :books, :as => :check_boxes, :wrapper_html => { :class => "multicolumn1" }, :collection => Book.where("category_id is NULL or category_id = ?", category.id).order("title ASC")
      f.input :order
    end
    f.buttons
  end

end
