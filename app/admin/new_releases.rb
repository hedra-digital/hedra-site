# -*- encoding : utf-8 -*-
ActiveAdmin.register NewRelease do
  menu :parent => "CMS"

  controller do
    def scoped_collection
      NewRelease.includes(:book)
    end
  end

  index do
    selectable_column
    column :id
    column :book, :collection => Book.order("title ASC").all
    column :updated_at
    default_actions
  end

end
