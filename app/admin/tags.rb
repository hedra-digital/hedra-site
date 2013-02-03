ActiveAdmin.register Tag do

  form do |f|
    f.inputs do
      f.input :name
      f.input :books, :as => :check_boxes, :collection => Book.order("title ASC").all, :wrapper_html => { :class => "multicolumn1" }
    end
    f.buttons
  end

end
