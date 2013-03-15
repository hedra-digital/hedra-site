ActiveAdmin.register Post  do
  form do |f|
    f.inputs do
      f.input :title
      f.input :body, :as => :ckeditor
      f.input :published_at, :as => :datepicker
      f.input :author_id, :as => :hidden, :value => current_admin_user.id
      f.input :book, :as => :select, :collection => Book.order("title ASC").all
    end
    f.buttons
  end

end
