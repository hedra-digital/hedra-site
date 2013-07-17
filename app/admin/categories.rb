ActiveAdmin.register Category do
  menu :parent => "CMS"

  form do |f|
    f.inputs do
      f.input :name
      f.input :books, :as => :check_boxes, :wrapper_html => { :class => "multicolumn1" }, :collection => Book.where("category_id is NULL or category_id = ?", category.id).order("title ASC")
    end
    f.buttons
  end

end
