ActiveAdmin.register Feature do

  controller do
    def scoped_collection
      Feature.includes(:book)
    end
  end

  index do
    selectable_column
    column :id
    column :book
    column :updated_at
    default_actions
  end

end
