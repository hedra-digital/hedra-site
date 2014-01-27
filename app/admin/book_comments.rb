# -*- encoding : utf-8 -*-
ActiveAdmin.register BookComment do
  menu :parent => "CMS"

  index do
    selectable_column
    column :content
    column :author
    column :vehicle
    column :book, :collection => Book.order("title ASC").all
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :book, :collection => Book.order("title ASC").all
      f.input :content
      f.input :author
      f.input :vehicle
      f.input :commented_at
    end
    f.buttons
  end
end
