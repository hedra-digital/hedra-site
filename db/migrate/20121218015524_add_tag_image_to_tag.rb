class AddTagImageToTag < ActiveRecord::Migration
  def change
    add_column :pages, :tag_image, :string
  end
end
