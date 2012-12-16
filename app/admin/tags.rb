ActiveAdmin.register Tag do
   form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :name, :label => "Nome"
      f.input :books, :as => :check_boxes
    end
    f.buttons
  end
end
