ActiveAdmin.register Recommendation do
  menu :parent => "CMS"

  controller do
    def scoped_collection
      Recommendation.includes(:book)
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
