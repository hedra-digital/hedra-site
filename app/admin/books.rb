ActiveAdmin.register Book do
  index do
    column :title
    column :isbn
    column :pages
    column :description
    column :updated_at
    default_actions
  end
end
