ActiveAdmin.register Category do

  form do |f|
    f.inputs do
      f.input :name
      f.input :books, :as => :check_boxes, :wrapper_html => { :class => "multicolumn1" }
    end
    f.buttons
  end

end
