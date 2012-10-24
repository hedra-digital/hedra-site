ActiveAdmin.register Book do

  index do
    column :title
    column :isbn
    column :pages
    column :description
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :isbn
      f.input :pages
      f.input :description
      f.input :binding_type
      f.has_many :participations do |association|
        association.input :role
        association.input :person
      end
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